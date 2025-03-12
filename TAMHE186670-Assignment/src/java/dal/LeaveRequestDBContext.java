/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.LeaveRequest;
import java.sql.*;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

public class LeaveRequestDBContext extends DBContext<LeaveRequest> {

    public List<Integer> getListEidManage(int managerEid) {
        List<Integer> eidList = new LinkedList<>();
        try {
            String sql = "WITH EmployeeHierarchy AS (\n"
                    + "    -- Trường hợp cơ sở: Lấy quản lý chính\n"
                    + "    SELECT eid, ename, email, managerid, did\n"
                    + "    FROM Employees\n"
                    + "    WHERE eid = ?\n"
                    + "    \n"
                    + "    UNION ALL\n"
                    + "    \n"
                    + "    -- Tìm tất cả nhân viên cấp dưới của những nhân viên đã chọn\n"
                    + "    SELECT e.eid, e.ename, e.email, e.managerid, e.did\n"
                    + "    FROM Employees e\n"
                    + "    INNER JOIN EmployeeHierarchy eh ON e.managerid = eh.eid\n"
                    + ")\n"
                    + "\n"
                    + "-- Lấy tất cả nhân viên cấp dưới, loại trừ quản lý gốc\n"
                    + "SELECT eid\n"
                    + "FROM EmployeeHierarchy\n"
                    + "ORDER BY eid;";

            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, managerEid);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                eidList.add(rs.getInt("eid"));
            }

        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (connection != null)
                try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return eidList;
    }

    public int count() {
        try {
            String sql = "SELECT COUNT(*) FROM LeaveRequests";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (connection != null)
                try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return -1;

    }

    public ArrayList<LeaveRequest> list(int pageindex, int pagesize, List<Integer> eids) {
        ArrayList<LeaveRequest> lrList = new ArrayList<>();

        try {
            StringBuilder sqlBuilder = new StringBuilder();
            sqlBuilder.append("SELECT lr.[lrid]\n")
                    .append("      ,lr.[title]\n")
                    .append("      ,lr.[reason]\n")
                    .append("      ,lr.[from]\n")
                    .append("      ,lr.[to]\n")
                    .append("      ,lr.[status]\n")
                    .append("      ,u.[username] as [createdbyusername]\n")
                    .append("      ,u.[displayname] as [createdbydisplayname]\n")
                    .append("      ,lr.[createddate]\n")
                    .append("      ,e.eid\n")
                    .append("      ,e.ename\n")
                    .append("      ,p.[username] as [processedbyusername]\n")
                    .append("      ,p.[displayname] as [processedbydisplayname]\n")
                    .append("  FROM [LeaveRequests] lr\n")
                    .append("  INNER JOIN Users u ON u.username = lr.createby\n")
                    .append("  INNER JOIN Employees e ON e.eid = lr.owner_eid\n")
                    .append("  INNER JOIN Departments d ON d.did = e.did\n")
                    .append("  LEFT JOIN Users p ON p.username = lr.processedby\n")
                    .append("  WHERE lr.owner_eid IN (");

            // Dynamically build the IN clause parameters
            for (int i = 0; i < eids.size(); i++) {
                if (i > 0) {
                    sqlBuilder.append(", ");
                }
                sqlBuilder.append("?");
            }

            sqlBuilder.append(")\n")
                    .append("  ORDER BY lrid DESC \n")
                    .append("  OFFSET (?-1)*? ROWS\n")
                    .append("  FETCH NEXT ? ROWS ONLY;");

            PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString());

            int index = 1;
            for (int eid : eids) {
                stm.setInt(index++, eid);
            }

            stm.setInt(index++, pageindex);
            stm.setInt(index++, pagesize);
            stm.setInt(index++, pagesize);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                LeaveRequest lr = new LeaveRequest();
                lr.setId(rs.getInt("lrid"));
                lr.setTitle(rs.getString("title"));
                lr.setReason(rs.getString("reason"));
                lr.setFrom(rs.getDate("from"));
                lr.setTo(rs.getDate("to"));
                lr.setStatus(rs.getString("status"));
                lr.setCreateddate(rs.getTimestamp("createddate"));

                User createdby = new User();
                createdby.setUsername(rs.getString("createdbyusername"));
                createdby.setDisplayname(rs.getString("createdbydisplayname"));
                lr.setCreatedby(createdby);

                String processbyusername = rs.getString("processedbyusername");
                if (processbyusername != null) {
                    User processby = new User();
                    processby.setUsername(processbyusername);
                    processby.setDisplayname(rs.getString("processedbydisplayname"));
                    lr.setProcessedby(processby);
                }

                lrList.add(lr);
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (connection != null)
                try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lrList;
    }

    @Override
    public ArrayList<LeaveRequest> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public LeaveRequest get(int id) {
        try {
            String sql = "SELECT lr.[lrid]\n"
                    + "      ,lr.[title]\n"
                    + "      ,lr.[reason]\n"
                    + "      ,lr.[from]\n"
                    + "      ,lr.[to]\n"
                    + "      ,lr.[status]\n"
                    + "      ,u.[username] as [createdbyusername]\n"
                    + "	  ,u.[displayname] as [createdbydisplayname]\n"
                    + "      ,lr.[createddate]\n"
                    + "      ,e.eid\n"
                    + "	  ,e.ename\n"
                    + "      ,p.[username] as [processedbyusername]\n"
                    + "	  ,p.[displayname] as [processedbydisplayname]\n"
                    + "  FROM [LeaveRequests] lr\n"
                    + "	INNER JOIN Users u ON u.username = lr.createby\n"
                    + "	INNER JOIN Employees e ON e.eid = lr.owner_eid\n"
                    + "	INNER JOIN Departments d ON d.did = e.did\n"
                    + "	LEFT JOIN Users p ON p.username = lr.processedby\n"
                    + "WHERE lr.lrid = ?";

            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                LeaveRequest lr = new LeaveRequest();
                lr.setId(rs.getInt("lrid"));
                lr.setTitle(rs.getString("title"));
                lr.setReason(rs.getString("reason"));
                lr.setFrom(rs.getDate("from"));
                lr.setTo(rs.getDate("to"));
                lr.setStatus(rs.getString("status"));
                lr.setCreateddate(rs.getTimestamp("createddate"));

                User createdby = new User();
                createdby.setUsername(rs.getString("createdbyusername"));
                createdby.setDisplayname(rs.getString("createdbydisplayname"));
                lr.setCreatedby(createdby);

                String processbyusername = rs.getString("processedbyusername");
                if (processbyusername != null) {
                    User processby = new User();
                    processby.setUsername(processbyusername);
                    processby.setDisplayname(rs.getString("processedbydisplayname"));
                    lr.setProcessedby(processby);
                }
                return lr;
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public void insert(LeaveRequest model) {
        try {
            connection.setAutoCommit(false);
            String sql = "INSERT INTO [LeaveRequests]\n"
                    + "           ([title]\n"
                    + "           ,[reason]\n"
                    + "           ,[from]\n"
                    + "           ,[to]\n"
                    + "           ,[status]\n"
                    + "           ,[createby]\n"
                    + "           ,[createddate]\n"
                    + "           ,[owner_eid])\n"
                    + "     VALUES\n"
                    + "           (\n"
                    + "           ?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,'Inprogress'\n"
                    + "           ,?\n"
                    + "           ,GETDATE()\n"
                    + "           ,?)";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, model.getTitle());
            stm.setString(2, model.getReason());
            stm.setDate(3, model.getFrom());
            stm.setDate(4, model.getTo());
            stm.setString(5, model.getCreatedby().getUsername());
            stm.setInt(6, model.getOwner().getId());
            stm.executeUpdate();

            //get request id
            String sql_getid = "SELECT @@IDENTITY as lrid";
            PreparedStatement stm_getid = connection.prepareStatement(sql_getid);
            ResultSet rs = stm_getid.executeQuery();
            if (rs.next()) {
                model.setId(rs.getInt("lrid"));
            }
            connection.commit();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex1);
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (connection != null)
                try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

    }

    @Override
    public void update(LeaveRequest model) {
        try {
            connection.setAutoCommit(false);
            String sql = "UPDATE [LeaveRequests]\n"
                    + "   SET [title] = ?\n"
                    + "      ,[reason] = ?\n"
                    + "      ,[from] = ?\n"
                    + "      ,[to] = ?\n"
                    + "      ,[owner_eid] = ?\n"
                    + " WHERE lrid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, model.getTitle());
            stm.setString(2, model.getReason());
            stm.setDate(3, model.getFrom());
            stm.setDate(4, model.getTo());
            stm.setInt(5, model.getOwner().getId());
            stm.setInt(6, model.getId());
            stm.executeUpdate();
            connection.commit();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex1);
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (connection != null)
                try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @Override
    public void delete(LeaveRequest model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public static void main(String[] args) {
        LeaveRequestDBContext dao = new LeaveRequestDBContext();
//        LeaveRequest model = new LeaveRequest();
//        model.setTitle("Tam xin nghi hoc");
//        model.setReason("Tai vi em bi om");
//        model.setStatus("Inprogress");
//
//        Employee e = new Employee();
//        e.setId(1);
//        model.setOwner(e);
//
//        User createdBy = new User();
//        createdBy.setUsername("tam");
//        model.setCreatedby(createdBy);
//
//        LocalDate from = LocalDate.of(2025, 3, 4);
//        LocalDate to = LocalDate.of(2025, 3, 6);
//
//        model.setFrom(Date.valueOf(from));
//        model.setTo(Date.valueOf(to));
//
//        dao.insert(model);

//        System.out.println(dao.list(1, 1));
//        List<Integer> i = new ArrayList<>();
//        i.add(1);
//        i.add(3);
        System.out.println(dao.get(2));
    }

}
