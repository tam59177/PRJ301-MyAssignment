/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.leaverequest;

import controller.authentication.BaseRequiredAuthenticationController;
import dal.LeaveRequestDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.LeaveRequest;
import model.User;

public class DetailLeaveRequestController extends BaseRequiredAuthenticationController {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        LeaveRequestDBContext db = new LeaveRequestDBContext();
        int lrid = Integer.parseInt(req.getParameter("lrid"));
        LeaveRequest lr = db.get(lrid);
 
        boolean isValidView = false;
        boolean canManage = false;

        if (user.getEmployee().getId() == lr.getOwner().getId()) {
            isValidView = true;
            canManage = false;
        } else {
            db = new LeaveRequestDBContext();
            List<Integer> listEidValid = db.getListEidManage(user.getEmployee().getId());

            for (Integer i : listEidValid) {
                if (lr.getOwner().getId() == i) {
                    canManage = true;
                    isValidView = true;
                    break;
                }
            }
        }

        if (!lr.getStatus().equalsIgnoreCase("Inprogress")) {
            canManage = false;
        }

        if (isValidView) {
            req.setAttribute("lr", lr);
            req.setAttribute("canManage", canManage);
            req.getRequestDispatcher("/view/request/detail.jsp").forward(req, resp);
        } else {
            req.setAttribute("errmessage", "Access Denied!");
            req.getRequestDispatcher("/leaverequest").forward(req, resp);
        }
    }
}
