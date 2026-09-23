package com.college.controller;

import com.college.dao.FacultyDAO;
import com.college.dao.SystemConfigDAO;
import com.college.dao.TimetableDAO;
import com.college.model.Faculty;
import com.college.model.PeriodTiming;
import com.college.model.SystemConfig;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.*;

@WebServlet("/facultyDashboard")
public class FacultyTimetableServlet extends HttpServlet {

    private final FacultyDAO      facultyDAO = new FacultyDAO();
    private final TimetableDAO    ttDAO      = new TimetableDAO();
    private final SystemConfigDAO configDAO  = new SystemConfigDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || !"FACULTY".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Always load full faculty list for sidebar
        List<Faculty> allFaculty = facultyDAO.getAllFaculty();
        request.setAttribute("allFaculty", allFaculty);

        String facultyIdParam = request.getParameter("facultyId");
        String view           = request.getParameter("view"); // "today" or "week"

        if (facultyIdParam == null || facultyIdParam.trim().isEmpty()) {
            request.getRequestDispatcher("faculty.jsp").forward(request, response);
            return;
        }

        int facultyId = Integer.parseInt(facultyIdParam.trim());

        // Find selected faculty object from the list
        Faculty selectedFaculty = null;
        for (Faculty f : allFaculty) {
            if (f.getId() == facultyId) { selectedFaculty = f; break; }
        }
        request.setAttribute("selectedFaculty", selectedFaculty);
        request.setAttribute("view", view == null ? "today" : view);

        // Load period timings + config (needed for both views)
        List<PeriodTiming> periods     = configDAO.getAllPeriods();
        SystemConfig       config      = configDAO.getSystemConfig();
        List<String>       workingDays = configDAO.getWorkingDayNames();
        periods.sort(Comparator.comparingInt(p -> toMinutes(p.getStartTime())));

        if ("week".equals(view)) {
            // ── WEEK VIEW — use TimetableDAO ─────────────────────────────────
            List<Map<String, String>> weekSchedule = ttDAO.getFacultyWeekSchedule(facultyId);
            List<Map<String, String>> columns      = buildColumns(periods, config);

            request.setAttribute("weekSchedule", weekSchedule);
            request.setAttribute("columns",      columns);
            request.setAttribute("workingDays",  workingDays);

        } else {
            // ── TODAY VIEW — use TimetableDAO ────────────────────────────────
            String today = LocalDate.now()
                    .getDayOfWeek()
                    .getDisplayName(TextStyle.FULL, Locale.ENGLISH);

            List<Map<String, String>> todaySchedule = ttDAO.getFacultyDaySchedule(facultyId, today);

            request.setAttribute("todaySchedule", todaySchedule);
            request.setAttribute("today",         today);
        }

        request.getRequestDispatcher("faculty.jsp").forward(request, response);
    }

    // ── Build ordered column list: periods + lunch/break markers ─────────────
    private List<Map<String, String>> buildColumns(List<PeriodTiming> periods, SystemConfig config) {
        List<Map<String, String>> cols = new ArrayList<>();
        if (periods == null || periods.isEmpty()) return cols;

        String  lunchStart = config != null ? config.getLunchStart()      : null;
        String  lunchEnd   = config != null ? config.getLunchEnd()        : null;
        boolean hasBreak   = config != null && config.isShortBreakEnabled();
        String  breakStart = config != null ? config.getShortBreakStart() : null;
        String  breakEnd   = config != null ? config.getShortBreakEnd()   : null;

        int lunchStartMin = toMinutes(lunchStart);
        int lunchEndMin   = toMinutes(lunchEnd);
        int breakStartMin = toMinutes(breakStart);
        int breakEndMin   = toMinutes(breakEnd);

        for (int i = 0; i < periods.size(); i++) {
            PeriodTiming cur = periods.get(i);

            Map<String, String> col = new LinkedHashMap<>();
            col.put("type",         "period");
            col.put("label",        "Period " + cur.getPeriodNumber());
            col.put("time",         to12hr(cur.getStartTime()) + " \u2013 " + to12hr(cur.getEndTime()));
            col.put("periodNumber", String.valueOf(cur.getPeriodNumber()));
            cols.add(col);

            if (i < periods.size() - 1) {
                PeriodTiming next      = periods.get(i + 1);
                int          curEnd    = toMinutes(cur.getEndTime());
                int          nextStart = toMinutes(next.getStartTime());

                if (nextStart > curEnd) {
                    if (lunchStart != null && lunchStartMin == curEnd && lunchEndMin == nextStart) {
                        cols.add(makeBreakCol("lunch", "Lunch Break",
                                to12hr(lunchStart) + " \u2013 " + to12hr(lunchEnd), "-1"));
                    } else if (hasBreak && breakStart != null
                            && breakStartMin == curEnd && breakEndMin == nextStart) {
                        cols.add(makeBreakCol("break", "Short Break",
                                to12hr(breakStart) + " \u2013 " + to12hr(breakEnd), "-2"));
                    } else if (lunchStart != null) {
                        cols.add(makeBreakCol("lunch", "Lunch Break",
                                to12hr(cur.getEndTime()) + " \u2013 " + to12hr(next.getStartTime()), "-1"));
                    }
                }
            }
        }
        return cols;
    }

    private Map<String, String> makeBreakCol(String type, String label, String time, String pNum) {
        Map<String, String> col = new LinkedHashMap<>();
        col.put("type", type); col.put("label", label);
        col.put("time", time); col.put("periodNumber", pNum);
        return col;
    }

    private int toMinutes(String time) {
        if (time == null || time.isEmpty()) return 0;
        try { String[] p = time.split(":"); return Integer.parseInt(p[0]) * 60 + Integer.parseInt(p[1]); }
        catch (Exception e) { return 0; }
    }

    private String to12hr(String time) {
        if (time == null || time.isEmpty()) return "";
        try {
            String[] parts = time.split(":");
            int hour = Integer.parseInt(parts[0]), min = Integer.parseInt(parts[1]);
            String ampm = hour >= 12 ? "PM" : "AM";
            if (hour == 0) hour = 12; else if (hour > 12) hour -= 12;
            return hour + ":" + String.format("%02d", min) + " " + ampm;
        } catch (Exception e) { return time; }
    }
}