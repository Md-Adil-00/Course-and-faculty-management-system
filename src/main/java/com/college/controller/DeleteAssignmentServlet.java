package com.college.controller;

import com.college.dao.AssignDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteAssignment")
public class DeleteAssignmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String facParam  = request.getParameter("facultyId");
        String subjParam = request.getParameter("subjectId");

        if (facParam != null && subjParam != null) {
            new AssignDAO().deleteAssignment(
                    Integer.parseInt(facParam.trim()),
                    Integer.parseInt(subjParam.trim())
            );
        }
        response.sendRedirect("adminDashboard");
    }
}