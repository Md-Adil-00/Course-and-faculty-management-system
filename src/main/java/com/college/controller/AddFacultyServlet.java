package com.college.controller;

import com.college.dao.FacultyDAO;
import com.college.model.Faculty;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/addFaculty")
public class AddFacultyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name       = request.getParameter("facultyName");
        String department = request.getParameter("department");

        if (name == null || name.trim().isEmpty() ||
                department == null || department.trim().isEmpty()) {
            response.sendRedirect("adminDashboard");
            return;
        }

        Faculty faculty = new Faculty();
        faculty.setName(name.trim());
        faculty.setDepartment(department.trim());

        FacultyDAO dao = new FacultyDAO();
        dao.addFaculty(faculty);

        response.sendRedirect("adminDashboard");
    }
}