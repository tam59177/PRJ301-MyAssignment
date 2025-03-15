/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.agenda;

import controller.authentication.BaseRequiredAuthenticationController;
import dal.EmployeeDBContext;
import dal.LeaveRequestDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import model.Agenda;
import model.Employee;
import model.User;

public class AgendaController extends BaseRequiredAuthenticationController {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        LeaveRequestDBContext db = new LeaveRequestDBContext();
        List<Agenda> aList = db.getListAgendaModel();

        EmployeeDBContext edb = new EmployeeDBContext();
        ArrayList<Employee> eList = edb.list();

        String startDateRaw = req.getParameter("start");
        String endDateRaw = req.getParameter("end");

        // Kiểm tra null trước khi kiểm tra isBlank() để tránh NullPointerException
        LocalDate start = (startDateRaw == null || startDateRaw.isBlank())
                ? LocalDate.now()
                : LocalDate.parse(startDateRaw);

        LocalDate end = (endDateRaw == null || endDateRaw.isBlank())
                ? LocalDate.now().plusDays(7)
                : LocalDate.parse(endDateRaw);

        List<LocalDate> dateList = getDatesBetween(start, end);

        req.setAttribute("start", start);
        req.setAttribute("end", end);
        req.setAttribute("eList", eList);
        req.setAttribute("dateList", dateList);
        req.setAttribute("agenda", aList);
        req.getRequestDispatcher("/view/agenda/agenda.jsp").forward(req, resp);
    }

    public List<LocalDate> getDatesBetween(LocalDate startDate, LocalDate endDate) {
        // Tạo danh sách các LocalDate giữa startDate và endDate (bao gồm cả 2 ngày)
        List<LocalDate> localDates = IntStream.rangeClosed(0, (int) ChronoUnit.DAYS.between(startDate, endDate))
                .mapToObj(startDate::plusDays)
                .collect(Collectors.toList());

        return localDates;
    }
}
