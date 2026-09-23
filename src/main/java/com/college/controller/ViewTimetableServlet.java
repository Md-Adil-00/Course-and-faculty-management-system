package com.college.controller;

import com.college.dao.BatchDAO;
import com.college.dao.SystemConfigDAO;
import com.college.dao.TimetableDAO;
import com.college.model.Batch;
import com.college.model.PeriodTiming;
import com.college.model.SystemConfig;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/viewTimetable")
public class ViewTimetableServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BatchDAO        batchDAO    = new BatchDAO();
        TimetableDAO    ttDAO       = new TimetableDAO();
        SystemConfigDAO configDAO   = new SystemConfigDAO();

        List<Batch>        allBatches    = batchDAO.getAllBatches();
        List<PeriodTiming> periodTimings = configDAO.getAllPeriods();
        SystemConfig       config        = configDAO.getSystemConfig();
        List<String>       workingDays   = configDAO.getWorkingDayNames();

        // Build timetable data per batch
        Map<Integer, List<Map<String, String>>> allTimetables = new LinkedHashMap<>();
        for (Batch b : allBatches) {
            allTimetables.put(b.getId(), ttDAO.getTimetableForBatch(b.getId()));
        }

        // ── Build the ordered column list from DB data ──────────────────────
        // Each column is a Map with keys: type (period/lunch/break), label, time, periodNumber
        List<Map<String, String>> columns = buildColumns(periodTimings, config);

        request.setAttribute("allBatches",    allBatches);
        request.setAttribute("allTimetables", allTimetables);
        request.setAttribute("workingDays",   workingDays);
        request.setAttribute("columns",       columns);
        request.setAttribute("config",        config);

        RequestDispatcher rd = request.getRequestDispatcher("viewTimetable.jsp");
        rd.forward(request, response);
    }

    // ── Build column list by reading period_timings + system_config ──────────
    // Logic:
    // 1. Sort all periods by start_time
    // 2. After each period, check if the next period's start_time != this period's end_time
    // 3. If there is a gap, check if it matches lunch_start/end or short_break_start/end
    // 4. Insert the appropriate break column between them
    private List<Map<String, String>> buildColumns(List<PeriodTiming> periods, SystemConfig config) {

        List<Map<String, String>> cols = new ArrayList<>();
        if (periods == null || periods.isEmpty()) return cols;

        // Sort by start time (they should already be ordered, but be safe)
        periods.sort(Comparator.comparingInt(p -> toMinutes(p.getStartTime())));

        String lunchStart  = config != null ? config.getLunchStart()      : null;
        String lunchEnd    = config != null ? config.getLunchEnd()         : null;
        boolean hasBreak   = config != null && config.isShortBreakEnabled();
        String breakStart  = config != null ? config.getShortBreakStart()  : null;
        String breakEnd    = config != null ? config.getShortBreakEnd()    : null;

        System.out.println("=== BUILD COLUMNS DEBUG ===");
        System.out.println("lunchStart='" + lunchStart + "' lunchEnd='" + lunchEnd + "'");
        System.out.println("breakEnabled=" + hasBreak + " breakStart='" + breakStart + "' breakEnd='" + breakEnd + "'");
        for (PeriodTiming p : periods) {
            System.out.println("Period " + p.getPeriodNumber() + ": start='" + p.getStartTime() + "' end='" + p.getEndTime() + "'");
        }

        int lunchStartMin = toMinutes(lunchStart);
        int lunchEndMin   = toMinutes(lunchEnd);
        int breakStartMin = toMinutes(breakStart);
        int breakEndMin   = toMinutes(breakEnd);

        for (int i = 0; i < periods.size(); i++) {
            PeriodTiming cur = periods.get(i);

            // Add the period column
            Map<String, String> col = new LinkedHashMap<>();
            col.put("type",         "period");
            col.put("label",        "Period " + cur.getPeriodNumber());
            col.put("time",         to12hr(cur.getStartTime()) + " – " + to12hr(cur.getEndTime()));
            col.put("periodNumber", String.valueOf(cur.getPeriodNumber()));
            cols.add(col);

            // After this period, check for a gap before the next one
            if (i < periods.size() - 1) {
                PeriodTiming next = periods.get(i + 1);
                int curEndMin    = toMinutes(cur.getEndTime());
                int nextStartMin = toMinutes(next.getStartTime());

                // A real gap exists between these two periods
                if (nextStartMin > curEndMin) {

                    // Check if gap matches lunch (compare by minutes)
                    if (lunchStart != null && lunchStartMin == curEndMin && lunchEndMin == nextStartMin) {
                        Map<String, String> lunch = new LinkedHashMap<>();
                        lunch.put("type",  "lunch");
                        lunch.put("label", "Lunch Break");
                        lunch.put("time",  to12hr(lunchStart) + " – " + to12hr(lunchEnd));
                        lunch.put("periodNumber", "-1");
                        cols.add(lunch);
                    }
                    // Check if gap matches short break (compare by minutes)
                    else if (hasBreak && breakStart != null && breakStartMin == curEndMin && breakEndMin == nextStartMin) {
                        Map<String, String> brk = new LinkedHashMap<>();
                        brk.put("type",  "break");
                        brk.put("label", "Short Break");
                        brk.put("time",  to12hr(breakStart) + " – " + to12hr(breakEnd));
                        brk.put("periodNumber", "-2");
                        cols.add(brk);
                    }
                    // Gap exists but doesn't match saved config exactly — still show as lunch
                    else if (lunchStart != null) {
                        Map<String, String> lunch = new LinkedHashMap<>();
                        lunch.put("type",  "lunch");
                        lunch.put("label", "Lunch Break");
                        lunch.put("time",  to12hr(cur.getEndTime()) + " – " + to12hr(next.getStartTime()));
                        lunch.put("periodNumber", "-1");
                        cols.add(lunch);
                    }
                }
            }
        }

        return cols;
    }

    private int toMinutes(String time) {
        if (time == null || time.isEmpty()) return 0;
        try {
            String[] p = time.split(":");
            return Integer.parseInt(p[0]) * 60 + Integer.parseInt(p[1]);
        } catch (Exception e) { return 0; }
    }

    private String to12hr(String time) {
        if (time == null || time.isEmpty()) return "";
        try {
            String[] parts = time.split(":");
            int hour = Integer.parseInt(parts[0]);
            int min  = Integer.parseInt(parts[1]);
            String ampm = hour >= 12 ? "PM" : "AM";
            if (hour == 0) hour = 12;
            else if (hour > 12) hour -= 12;
            return hour + ":" + String.format("%02d", min) + " " + ampm;
        } catch (Exception e) { return time; }
    }
}
