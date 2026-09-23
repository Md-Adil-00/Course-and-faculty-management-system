package com.college.controller;

import com.college.dao.SubjectDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteSubject")
public class DeleteSubjectServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("subjectId");
        if (idParam != null && !idParam.trim().isEmpty()) {
            new SubjectDAO().deleteSubject(Integer.parseInt(idParam.trim()));
        }
        response.sendRedirect("adminDashboard");
    }
}