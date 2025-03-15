/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.authentication;

import dal.LeaveRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.BaseModel;
import model.User;

/**
 *
 * @author sonnt-local
 */
public abstract class BaseRecordAccessControlByOwnerController<T extends BaseModel>
        extends BaseRequiredAuthenticationController {

    private boolean isAllowedAccess(T entity, User user, String type) {
        switch (type) {
            case "all":
                return (entity.getCreatedby().getUsername().equals(user.getUsername()));
            case "state":
                LeaveRequestDBContext db = new LeaveRequestDBContext();
                List<Integer> listEidValid = db.getListEidManage(user.getEmployee().getId());

                for (Integer i : listEidValid) {
                    if (entity.getCreatedby().getEmployee().getId() == i) {
                        return true;
                    }
                }
            default:
                return (entity.getCreatedby().getUsername().equals(user.getUsername()));
        }
    }

    protected abstract T getModel(int id);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        T model = getModel(Integer.parseInt(req.getParameter("lrid")));
        String type = req.getParameter("type");
        if (isAllowedAccess(model, user, type)) {
            //do business
            doPost(req, resp, user, model);
        } else {
            req.setAttribute("errmessage", getAccessDeniedMessage(user, model));
            req.getRequestDispatcher("/leaverequest").forward(req, resp);
        }
    }

    protected abstract String getAccessDeniedMessage(User u, T model);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        T model = getModel(Integer.parseInt(req.getParameter("lrid")));
        String type = req.getParameter("type");
        if (isAllowedAccess(model, user, type)) {
            //do business
            doGet(req, resp, user, model);
        } else {
            req.setAttribute("errmessage", getAccessDeniedMessage(user, model));
            req.getRequestDispatcher("/leaverequest").forward(req, resp);
        }

    }

    protected abstract void doGet(HttpServletRequest req, HttpServletResponse resp, User user, T model) throws ServletException, IOException;

    protected abstract void doPost(HttpServletRequest req, HttpServletResponse resp, User user, T model) throws ServletException, IOException;
}
