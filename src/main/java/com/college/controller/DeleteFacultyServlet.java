package com.college.controller;

import com.college.dao.FacultyDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteFaculty")
public class DeleteFacultyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("facultyId");
        if (idParam != null && !idParam.trim().isEmpty()) {
            new FacultyDAO().deleteFaculty(Integer.parseInt(idParam.trim()));
        }
        response.sendRedirect("adminDashboard");
    }
}