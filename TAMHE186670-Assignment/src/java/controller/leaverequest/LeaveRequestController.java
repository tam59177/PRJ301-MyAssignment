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
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import model.LeaveRequest;
import model.User;

public class LeaveRequestController extends BaseRequiredAuthenticationController {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        int pagesize = 10;
        String raw_pageindex = req.getParameter("page");
        if (raw_pageindex == null || raw_pageindex.length() == 0) {
            raw_pageindex = "1";
        }
        int pageindex = Integer.parseInt(raw_pageindex);

        LeaveRequestDBContext db = new LeaveRequestDBContext();
        List<Integer> eidList = new LinkedList();
        eidList = db.getListEidManage(user.getEmployee().getId());

        db = new LeaveRequestDBContext();
        ArrayList<LeaveRequest> lrList = db.list(pageindex, pagesize, eidList);
        db = new LeaveRequestDBContext();
        int count = db.count();
        int totalpage = (count % pagesize == 0) ? (count / pagesize) : (count / pagesize) + 1;

        req.setAttribute("totalpage", totalpage);
        req.setAttribute("pageindex", pageindex);
        req.setAttribute("lrList", lrList);
        req.getRequestDispatcher("view/request/request.jsp").forward(req, resp);
    }

}
