package com.college.controller;

import com.college.dao.BatchDAO;
import com.college.dao.FacultyDAO;
import com.college.dao.SubjectDAO;
import com.college.dao.FacultySubjectDAO;
import com.college.model.Batch;
import com.college.model.Faculty;
import com.college.model.Subject;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        FacultyDAO facultyDAO = new FacultyDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        BatchDAO batchDAO = new BatchDAO();
        FacultySubjectDAO fsDAO = new FacultySubjectDAO();

        List<Faculty> facultyList = facultyDAO.getAllFaculty();
        List<Subject> subjectList = subjectDAO.getAllSubjects();
        List<Batch> batches = batchDAO.getAllBatches();
        List<Map<String, String>> assignments = fsDAO.getAllAssignments();

        request.setAttribute("facultyList",  facultyList);
        request.setAttribute("subjectList",  subjectList);
        request.setAttribute("batches",      batches);
        request.setAttribute("assignments",  assignments);

        RequestDispatcher rd = request.getRequestDispatcher("admin.jsp");
        rd.forward(request, response);
    }
}