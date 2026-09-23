package com.college.controller;

import com.college.dao.SystemConfigDAO;
import com.college.model.SystemConfig;
import com.college.model.PeriodTiming;
import com.college.model.WorkingDay;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/saveConfig")
public class SaveConfigServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String periodCountParam = request.getParameter("periodCount");
        if (periodCountParam == null || periodCountParam.trim().isEmpty()) {
            response.sendRedirect("adminDashboard");
            return;
        }

        int periodCount = Integer.parseInt(periodCountParam.trim());

        SystemConfig config = new SystemConfig();
        config.setPeriodCount(periodCount);
        config.setLunchStart(request.getParameter("lunchStart"));
        config.setLunchEnd(request.getParameter("lunchEnd"));

        boolean shortBreakEnabled = request.getParameter("shortBreakEnabled") != null;
        config.setShortBreakEnabled(shortBreakEnabled);
        config.setShortBreakStart(request.getParameter("shortBreakStart"));
        config.setShortBreakEnd(request.getParameter("shortBreakEnd"));

        // Period timings
        List<PeriodTiming> periodList = new ArrayList<>();
        for (int i = 1; i <= periodCount; i++) {
            String start = request.getParameter("p" + i + "Start");
            String end   = request.getParameter("p" + i + "End");
            if (start != null && end != null) {
                PeriodTiming p = new PeriodTiming();
                p.setPeriodNumber(i);
                p.setStartTime(start);
                p.setEndTime(end);
                periodList.add(p);
            }
        }

        // Working days
        String[] selectedDays = request.getParameterValues("workingDays");
        List<WorkingDay> workingDays = new ArrayList<>();
        if (selectedDays != null) {
            for (String day : selectedDays) {
                WorkingDay wd = new WorkingDay();
                wd.setDayName(day);
                workingDays.add(wd);
            }
        }

        SystemConfigDAO dao = new SystemConfigDAO();
        dao.saveConfig(config, periodList, workingDays);

        response.sendRedirect("adminDashboard");
    }
}