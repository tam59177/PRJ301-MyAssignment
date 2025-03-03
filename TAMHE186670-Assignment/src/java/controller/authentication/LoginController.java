/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.authentication;

import dal.EmployeeDBContext;
import dal.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Employee;
import model.User;

public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("remember");

        UserDBContext db = new UserDBContext();

        User user = db.get(username, password);

        if (user != null) {
            EmployeeDBContext edb = new EmployeeDBContext();

            Employee profile = edb.get(user.getEmployee().getId());
            profile.setManager(user.getEmployee().getManager());
            user.setEmployee(profile);

            if ("on".equalsIgnoreCase(rememberMe)) {
                Cookie usernameCookie = new Cookie("username", username);
                Cookie passwordCookie = new Cookie("password", password);
                Cookie rememberCookie = new Cookie("remember", rememberMe);

                int expiry = 7 * 24 * 60 * 60;
                usernameCookie.setMaxAge(expiry);
                passwordCookie.setMaxAge(expiry);
                rememberCookie.setMaxAge(expiry);

                resp.addCookie(usernameCookie);
                resp.addCookie(passwordCookie);
                resp.addCookie(rememberCookie);
            } else {
                Cookie usernameCookie = new Cookie("username", "");
                Cookie passwordCookie = new Cookie("password", "");
                Cookie rememberMeCookie = new Cookie("remember", "");

                usernameCookie.setMaxAge(0);
                passwordCookie.setMaxAge(0);
                rememberMeCookie.setMaxAge(0);

                resp.addCookie(usernameCookie);
                resp.addCookie(passwordCookie);
                resp.addCookie(rememberMeCookie);
            }

            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            resp.sendRedirect("home");
        } else {
            req.setAttribute("message", "Access Denied!");
            req.getRequestDispatcher("view/authentication/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cookie[] cookies = req.getCookies();

        String username = "";
        String password = "";
        String remember = "";

        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("username".equals(c.getName())) {
                    username = c.getValue();
                }
                if ("password".equals(c.getName())) {
                    password = c.getValue();
                }
                if ("remember".equals(c.getName())) {
                    remember = c.getValue();
                }
            }

            UserDBContext db = new UserDBContext();
            User user = db.get(username, password);
            if (user != null) {
                EmployeeDBContext edb = new EmployeeDBContext();
                Employee profile = edb.get(user.getEmployee().getId());
                profile.setManager(user.getEmployee().getManager());
                user.setEmployee(profile);
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                resp.sendRedirect("home");
                return;
            }
        }

        req.getRequestDispatcher("view/authentication/login.jsp").forward(req, resp);
    }
}
