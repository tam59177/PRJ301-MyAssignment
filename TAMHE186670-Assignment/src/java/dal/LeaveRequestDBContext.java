/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.LeaveRequest;
import java.sql.*;
import java.time.LocalDate;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Agenda;
import model.Department;
import model.Employee;
import model.User;

public class LeaveRequestDBContext extends DBContext<LeaveRequest> {

    public List<Agenda> getListAgendaModel() {
        List<Agenda> aList = new ArrayList<>();

        try {
            connection.setAutoCommit(false);
            String sql = "-- Tạo bảng các ngày từ ngày bắt đầu đến ngày kết thúc của mỗi yêu cầu nghỉ phép\n"
                    + "WITH DateRange AS (\n"
                    + "    SELECT \n"
                    + "        lr.lrid,\n"
                    + "        lr.owner_eid,\n"
                    + "        lr.[from], \n"
                    + "        lr.[to],\n"
                    + "        DATEADD(DAY, number, lr.[from]) AS off_date\n"
                    + "    FROM [MyAssignment].[dbo].[LeaveRequests] lr\n"
                    + "    CROSS APPLY (\n"
                    + "        SELECT TOP (DATEDIFF(DAY, lr.[from], lr.[to]) + 1) \n"
                    + "            number = ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1\n"
                    + "        FROM master.dbo.spt_values\n"
                    + "    ) AS Numbers\n"
                    + "    WHERE lr.status = 'Approved' -- Giả sử chỉ lấy các yêu cầu nghỉ phép đã được duyệt\n"
                    + ")\n"
                    + "\n"
                    + "-- Truy vấn chính để lấy kết quả với thông tin nhân viên\n"
                    + "SELECT \n"
                    + "    e.eid AS EmployeeID,\n"
                    + "    e.ename AS EmployeeName,\n"
                    + "    e.email AS EmployeeEmail,\n"
                    + "    e.managerid AS ManagerID,\n"
                    + "    e.did AS DepartmentID,\n"
                    + "    dr.off_date AS OffWorkDate,\n"
                    + "    dr.lrid AS LeaveRequestID,\n"
                    + "    CASE \n"
                    + "        WHEN DATENAME(dw, dr.off_date) IN ('Saturday', 'Sunday') THEN 'Weekend'\n"
                    + "        ELSE 'Working Day'\n"
                    + "    END AS DayType\n"
                    + "FROM DateRange dr\n"
                    + "JOIN [MyAssignment].[dbo].[Employees] e ON dr.owner_eid = e.eid\n"
                    + "ORDER BY dr.off_date;";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Employee emp = new Employee();
                emp.setId(rs.getInt("EmployeeID"));
                emp.setName(rs.getString("EmployeeName"));
                emp.setEmail(rs.getString("EmployeeEmail"));

                Employee manager = new Employee();
                manager.setId(rs.getInt("ManagerID"));

                emp.setManager(manager);

                Department d = new Department();
                d.setId(rs.getInt("DepartmentID"));

                Agenda a = new Agenda();
                a.setEmp(emp);
                a.setLrid(rs.getInt("LeaveRequestID"));
                a.setOffWorkDate(rs.getDate("OffWorkDate"));
                a.setWorkDateType(rs.getString("DayType"));

                aList.add(a);
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

        return aList;
    }

    public void updateLeaveRequestState(String state, int lrid, String username) {
        try {
            connection.setAutoCommit(false);
            String sql = "UPDATE [LeaveRequests]\n"
                    + "   SET [status] = ?, [processedby] = ? \n"
                    + " WHERE lrid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, state);
            stm.setString(2, username);
            stm.setInt(3, lrid);
            stm.executeUpdate();
            connection.commit();

        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class
                    .getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex1);
            }
        } finally {
            try {
                connection.setAutoCommit(true);

            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            if (connection != null)
                try {
                connection.close();

            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

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
            Logger.getLogger(LeaveRequestDBContext.class
                    .getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (connection != null)
                try {
                connection.close();

            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class
                        .getName()).log(Level.SEVERE, null, ex);
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
                    + "      ,lr.[owner_eid]\n"
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

                Employee owner = new Employee();
                owner.setId(rs.getInt("owner_eid"));
                lr.setOwner(owner);

                createdby.setEmployee(owner);
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
            Logger.getLogger(LeaveRequestDBContext.class
                    .getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(LeaveRequestDBContext.class
                    .getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex1);
            }
        } finally {
            try {
                connection.setAutoCommit(true);

            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            if (connection != null)
                try {
                connection.close();

            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class
                        .getName()).log(Level.SEVERE, null, ex);
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
                    + " WHERE lrid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, model.getTitle());
            stm.setString(2, model.getReason());
            stm.setDate(3, model.getFrom());
            stm.setDate(4, model.getTo());
            stm.setInt(5, model.getId());
            stm.executeUpdate();
            connection.commit();

        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class
                    .getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex1);
            }
        } finally {
            try {
                connection.setAutoCommit(true);

            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            if (connection != null)
                try {
                connection.close();

            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @Override
    public void delete(LeaveRequest model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public static void main(String[] args) {
        LeaveRequestDBContext dao = new LeaveRequestDBContext();
        LeaveRequest model = new LeaveRequest();
        model.setId(1);
        model.setTitle("testupdate");
        model.setReason("Tai vi em bi om");

        LocalDate from = LocalDate.of(2025, 3, 4);
        LocalDate to = LocalDate.of(2025, 3, 6);

        model.setFrom(Date.valueOf(from));
        model.setTo(Date.valueOf(to));
//
//        dao.insert(model);

//        System.out.println(dao.list(1, 1));
        List<Integer> i = new ArrayList<>();
        i.add(1);
        i.add(2);
        i.add(3);
        i.add(4);
//        System.out.println(dao.getListEidManage(3));
//        dao.updateLeaveRequestState("Approved", 1);
//        System.out.println(dao.list(1, 10, i));
        dao.updateLeaveRequestState("Approved", 1, "tam");
    }

}
