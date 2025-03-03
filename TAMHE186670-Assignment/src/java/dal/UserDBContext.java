/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.User;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;
import model.Feature;
import model.Role;

public class UserDBContext extends DBContext<User> {

    public User get(String username, String password) {
        try {
            String sql = "SELECT u.username,u.displayname\n"
                    + "                    ,r.rid, r.rname\n"
                    + "                    ,f.fid,f.url\n"
                    + "					,e.eid, e.ename\n"
                    + "					,m.eid as [managerid]\n"
                    + "					,m.ename as [managerename]\n"
                    + "                    FROM Users u \n"
                    + "					INNER JOIN Employees e ON e.eid = u.eid\n"
                    + "					LEFT JOIN Employees m ON e.managerid = m.eid\n"
                    + "					LEFT JOIN UserRole ur ON ur.username = u.username\n"
                    + "                    LEFT JOIN Roles r ON r.rid = ur.rid\n"
                    + "                    LEFT JOIN RoleFeature rf ON r.rid = rf.rid\n"
                    + "                    LEFT JOIN Features f ON f.fid = rf.fid\n"
                    + "                    WHERE u.username = ? AND u.password = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, password);
            ResultSet rs = stm.executeQuery();
            User user = null;
            Role current_role = new Role();
            current_role.setId(-1);
            while (rs.next()) {
                if (user == null) {
                    user = new User();
                    user.setUsername(username);
                    user.setDisplayname(rs.getNString("displayname"));
                    Employee e = new Employee();
                    e.setId(rs.getInt("eid"));
                    e.setName(rs.getString("ename"));
                    user.setEmployee(e);
                    int managerid = rs.getInt("managerid");
                    if (managerid != 0) {
                        Employee m = new Employee();
                        m.setId(managerid);
                        m.setName(rs.getString("managerename"));
                        e.setManager(m);
                    }

                }
                int rid = rs.getInt("rid");
                if (rid > 0 && rid != current_role.getId()) {
                    current_role = new Role();
                    current_role.setId(rid);
                    current_role.setName(rs.getString("rname"));
                    current_role.getUsers().add(user);
                    user.getRoles().add(current_role);
                }

                int fid = rs.getInt("fid");
                if (fid > 0) {
                    Feature f = new Feature();
                    f.setId(fid);
                    f.setUrl(rs.getString("url"));
                    current_role.getFeatures().add(f);
                    f.getRoles().add(current_role);
                }
            }
            return user;
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (connection != null)
                try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return null;
    }

    @Override
    public ArrayList<User> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public User get(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void insert(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
