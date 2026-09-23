package com.college.controller;

import com.college.dao.BatchDAO;
import com.college.model.Batch;
import com.college.service.TimetableGenerator;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet("/generateTimetable")
public class GenerateTimetableServlet extends HttpServlet {

    private BatchDAO batchDAO = new BatchDAO();

    // GET — just forward to generateTimetable.jsp (no dropdown needed)
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher rd = request.getRequestDispatcher("generateTimetable.jsp");
        rd.forward(request, response);
    }

    // POST — generate timetables for ALL batches at once
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        List<Batch> allBatches = batchDAO.getAllBatches();

        if (allBatches.isEmpty()) {
            request.setAttribute("error", "No batches found. Please create batches first.");
            RequestDispatcher rd = request.getRequestDispatcher("generateTimetable.jsp");
            rd.forward(request, response);
            return;
        }

        TimetableGenerator generator = new TimetableGenerator();
        String result = generator.generateAll(allBatches);
        System.out.println(result);

        // Pass result to view page as a flash message
        request.getSession().setAttribute("genMessage", result);

        response.sendRedirect("viewTimetable");
    }
}