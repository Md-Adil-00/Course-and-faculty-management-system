package com.college.controller;

import com.college.dao.AssignDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/assignSubject")
public class AssignSubjectServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String facParam  = request.getParameter("facultyId");
        String subjParam = request.getParameter("subjectId");

        if (facParam == null || subjParam == null) {
            response.sendRedirect("adminDashboard");
            return;
        }

        int facultyId = Integer.parseInt(facParam);
        int subjectId = Integer.parseInt(subjParam);

        AssignDAO dao = new AssignDAO();

        // Prevent duplicate assignments
        if (!dao.isAlreadyAssigned(facultyId, subjectId)) {
            dao.assignSubject(facultyId, subjectId);
        }

        response.sendRedirect("adminDashboard");
    }
}