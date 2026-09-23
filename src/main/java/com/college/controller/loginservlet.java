package com.college.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;

@WebServlet("/login")
public class loginservlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        if(email.equals("admin@gmail.com") && password.equals("admin123")) {

            session.setAttribute("role", "ADMIN");
            session.setAttribute("user", email);
            response.sendRedirect("adminDashboard");

        } else if(email.equals("faculty@gmail.com") && password.equals("faculty123")) {

            session.setAttribute("role", "FACULTY");
            session.setAttribute("user", email);
            response.sendRedirect("facultyDashboard");

        } else {
            response.getWriter().println("Invalid credentials");
        }
    }
}