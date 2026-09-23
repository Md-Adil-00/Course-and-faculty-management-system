package com.college.controller;

import com.college.dao.BatchDAO;
import com.college.model.Batch;
import jakarta.servlet.RequestDispatcher;       // ✅ Fixed: jakarta not javax
import jakarta.servlet.ServletException;        // ✅ Fixed: jakarta not javax
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/generateTimetablePage")
public class LoadGenerateTimetableServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BatchDAO dao = new BatchDAO();

        List<Batch> batches = dao.getAllBatches();

        request.setAttribute("batches", batches);

        request.getRequestDispatcher("admin.jsp").forward(request, response); // ✅ Fixed: was forwarding to missing JSP
    }
}