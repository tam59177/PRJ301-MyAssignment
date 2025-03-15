/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.leaverequest;

import controller.authentication.BaseRecordAccessControlByOwnerController;
import dal.LeaveRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import model.Employee;
import model.LeaveRequest;
import model.User;

public class EditLeaveRequestController extends BaseRecordAccessControlByOwnerController<LeaveRequest> {

    @Override
    protected LeaveRequest getModel(int id) {
        LeaveRequestDBContext db = new LeaveRequestDBContext();
        return db.get(id);
    }

    @Override
    protected String getAccessDeniedMessage(User u, LeaveRequest model) {
        return "You are not the author of that leave request " + model.getId();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user, LeaveRequest model) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user, LeaveRequest model) throws ServletException, IOException {
        String type = req.getParameter("type");
        LeaveRequestDBContext db;

        switch (type) {
            case "all":
                model.setTitle(req.getParameter("title"));
                model.setReason(req.getParameter("reason"));
                model.setFrom(Date.valueOf(req.getParameter("from")));
                model.setTo(Date.valueOf(req.getParameter("to")));

                db = new LeaveRequestDBContext();
                db.update(model);

                req.setAttribute("message", "Update Leave Request Success!");
                req.getRequestDispatcher("/leaverequest").forward(req, resp);
                break;
            case "state":
                String state = req.getParameter("state");

                db = new LeaveRequestDBContext();
                db.updateLeaveRequestState(state, model.getId());

                req.setAttribute("message", state + " Leave Request Success!");
                req.getRequestDispatcher("/leaverequest").forward(req, resp);
                break;
        }
    }

}
