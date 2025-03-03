/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.BaseModel;
import model.User;

/**
 *
 * @author sonnt-local
 */
public abstract class BaseRecordAccessControlByOwnerController<T extends BaseModel>
        extends BaseRequiredAuthenticationController {

    private boolean isAllowedAccess(T entity, User user) {
        return (entity.getCreatedby().getUsername().equals(user.getUsername()));
    }

    protected abstract T getModel(int id);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        T model = getModel(Integer.parseInt(req.getParameter("id")));
        if (isAllowedAccess(model, user)) {
            //do business
            doPost(req, resp, user, model);
        } else {
            resp.getWriter().println(getAccessDeniedMessage(user, model));
        }
    }

    protected abstract String getAccessDeniedMessage(User u, T model);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        T model = getModel(Integer.parseInt(req.getParameter("id")));
        if (isAllowedAccess(model, user)) {
            //do business
            doGet(req, resp, user, model);
        } else {
            resp.getWriter().println(getAccessDeniedMessage(user, model));
        }

    }

    protected abstract void doGet(HttpServletRequest req, HttpServletResponse resp, User user, T model) throws ServletException, IOException;

    protected abstract void doPost(HttpServletRequest req, HttpServletResponse resp, User user, T model) throws ServletException, IOException;
}
