package com.college.controller;

import com.college.dao.BatchDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/createBatch")
public class CreateBatchServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String branch      = request.getParameter("branch").trim().toLowerCase();
        int    divisions   = Integer.parseInt(request.getParameter("divisions"));
        int    semester    = Integer.parseInt(request.getParameter("semester"));

        BatchDAO dao = new BatchDAO();

        // Creates Div A, B, C... automatically based on count
        dao.createBatches(branch, semester, divisions);

        response.sendRedirect("adminDashboard");
    }
}