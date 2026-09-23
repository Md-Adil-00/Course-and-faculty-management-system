package com.college.controller;

import com.college.model.Subject;
import com.college.dao.SubjectDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/addSubject")
public class AddSubjectServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subjectName = request.getParameter("subjectName");
        String subjectCode = request.getParameter("subjectCode");
        String branch      = request.getParameter("branch");
        String hpwParam    = request.getParameter("hoursPerWeek");
        String semParam    = request.getParameter("semester");

        if (subjectName == null || subjectName.trim().isEmpty() ||
                branch == null || branch.trim().isEmpty() ||
                hpwParam == null || semParam == null) {
            response.sendRedirect("adminDashboard");
            return;
        }

        int hoursPerWeek = Integer.parseInt(hpwParam.trim());
        int semester     = Integer.parseInt(semParam.trim());

        // is_lab checkbox — present means true
        boolean isLab = request.getParameter("isLab") != null;

        Subject subject = new Subject();
        subject.setSubjectName(subjectName.trim());
        subject.setSubjectCode(subjectCode != null ? subjectCode.trim() : "");
        subject.setHoursPerWeek(hoursPerWeek);
        subject.setBranch(branch.trim().toLowerCase()); // consistent lowercase like batch branch
        subject.setSemester(semester);
        subject.setLab(isLab);

        SubjectDAO dao = new SubjectDAO();
        dao.addSubject(subject);

        response.sendRedirect("adminDashboard");
    }
}