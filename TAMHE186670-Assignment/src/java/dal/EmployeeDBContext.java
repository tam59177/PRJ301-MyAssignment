/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Department;
import model.Employee;

public class EmployeeDBContext extends DBContext<Employee> {
    
    @Override
    public ArrayList<Employee> list() {
        ArrayList<Employee> employees = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Employees";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                e.setEmail(rs.getString("email"));
                
                Employee manager = new Employee();
                manager.setId(rs.getInt("managerid"));
                
                e.setManager(manager);
                
                Department d = new Department();
                d.setId(rs.getInt("did"));
                
                e.setDept(d);
                
                employees.add(e);
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (connection != null)
                try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return employees;
    }
    
    @Override
    public Employee get(int id) {
        ArrayList<Employee> employees = new ArrayList<>();
        try {
            String sql = "WITH EmployeeTree AS (\n"
                    + "    SELECT eid, managerid, 0 AS Level\n"
                    + "    FROM Employees\n"
                    + "    WHERE eid = ?\n"
                    + "\n"
                    + "    UNION ALL\n"
                    + "\n"
                    + "    SELECT e.eid, e.managerid, et.Level + 1\n"
                    + "    FROM Employees e\n"
                    + "    INNER JOIN EmployeeTree et ON e.managerid = et.eid\n"
                    + ")\n"
                    + "SELECT s.eid as [staffid],e.ename as [staffname],s.managerid, s.Level\n"
                    + "		,d.did as [staffdid], d.dname as [staffdname]\n"
                    + "FROM EmployeeTree s INNER JOIN Employees e ON s.eid = e.eid\n"
                    + "					INNER JOIN Departments d ON d.did = e.did\n"
                    + "ORDER BY Level;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Employee e = new Employee();
                e.setId(rs.getInt("staffid"));
                e.setName(rs.getString("staffname"));
                Department d = new Department();
                d.setId(rs.getInt("staffdid"));
                d.setName(rs.getString("staffdname"));
                e.setDept(d);
                Employee manager = new Employee();
                manager.setId(rs.getInt("managerid"));
                e.setManager(manager);
                employees.add(e);
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (connection != null)
                try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if (employees.size() > 0) {
            Employee root = employees.get(0);
            // sub tree;
            for (Employee employee : employees) {
                Employee manager = getDirectManager(employees, employee);
                employee.setManager(manager);
                if (manager != null) {
                    manager.getDirectstaffs().add(employee);
                }
                if (employee != root) {
                    root.getStaffs().add(employee);
                }
            }
            return root;
        } else {
            return null;
        }
    }
    
    private Employee getDirectManager(ArrayList<Employee> emps, Employee e) {
        for (Employee emp : emps) {
            if (e.getManager().getId() == emp.getId()) {
                return emp;
            }
        }
        return null;
    }
    
    @Override
    public void insert(Employee model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    @Override
    public void update(Employee model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    @Override
    public void delete(Employee model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    public static void main(String[] args) {
        EmployeeDBContext dao = new EmployeeDBContext();
        System.out.println(dao.list().size());
    }
}
