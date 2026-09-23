package com.college.dao;

import com.college.model.SystemConfig;
import com.college.model.PeriodTiming;
import com.college.model.WorkingDay;
import com.college.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SystemConfigDAO {

    // ================= SAVE CONFIG =================
    public void saveConfig(SystemConfig config,
                           List<PeriodTiming> periods,
                           List<WorkingDay> workingDays) {

        try (Connection con = DBConnection.getConnection()) {

            con.createStatement().executeUpdate("DELETE FROM system_config");
            con.createStatement().executeUpdate("DELETE FROM period_timings");
            con.createStatement().executeUpdate("DELETE FROM working_days");

            String sql = "INSERT INTO system_config " +
                    "(period_count, lunch_start, lunch_end, short_break_enabled, short_break_start, short_break_end) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, config.getPeriodCount());
            ps.setString(2, config.getLunchStart());
            ps.setString(3, config.getLunchEnd());
            ps.setBoolean(4, config.isShortBreakEnabled());
            ps.setString(5, config.getShortBreakStart());
            ps.setString(6, config.getShortBreakEnd());

            ps.executeUpdate();

            String periodSql = "INSERT INTO period_timings (period_number, start_time, end_time) VALUES (?, ?, ?)";
            PreparedStatement periodPs = con.prepareStatement(periodSql);

            for (PeriodTiming p : periods) {
                periodPs.setInt(1, p.getPeriodNumber());
                periodPs.setString(2, p.getStartTime());
                periodPs.setString(3, p.getEndTime());
                periodPs.executeUpdate();
            }

            String workingSql = "INSERT INTO working_days (day_name) VALUES (?)";
            PreparedStatement workingPs = con.prepareStatement(workingSql);

            for (WorkingDay wd : workingDays) {
                workingPs.setString(1, wd.getDayName());
                workingPs.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= FETCH SYSTEM CONFIG =================
    public SystemConfig getSystemConfig() {

        SystemConfig config = null;

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM system_config LIMIT 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                config = new SystemConfig();
                config.setPeriodCount(rs.getInt("period_count"));
                config.setLunchStart(rs.getString("lunch_start"));
                config.setLunchEnd(rs.getString("lunch_end"));
                config.setShortBreakEnabled(rs.getBoolean("short_break_enabled"));
                config.setShortBreakStart(rs.getString("short_break_start"));
                config.setShortBreakEnd(rs.getString("short_break_end"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return config;
    }

    // ================= GET PERIOD COUNT (For Generator) =================
    public int getPeriodCount() {

        int count = 0;

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT period_count FROM system_config LIMIT 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("period_count");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    // ================= FETCH PERIOD TIMINGS =================
    public List<PeriodTiming> getAllPeriods() {

        List<PeriodTiming> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM period_timings ORDER BY period_number";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PeriodTiming p = new PeriodTiming();
                p.setPeriodNumber(rs.getInt("period_number"));
                p.setStartTime(rs.getString("start_time"));
                p.setEndTime(rs.getString("end_time"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= FETCH WORKING DAYS (MODEL) =================
    public List<WorkingDay> getWorkingDays() {

        List<WorkingDay> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM working_days";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                WorkingDay wd = new WorkingDay();
                wd.setDayName(rs.getString("day_name"));
                list.add(wd);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= GET WORKING DAY NAMES (For Generator) =================
    public List<String> getWorkingDayNames() {

        List<String> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT day_name FROM working_days";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("day_name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= CHECK IF PERIOD IS LUNCH =================
    public boolean isLunchPeriod(int periodNumber) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT pt.period_number " +
                    "FROM period_timings pt, system_config sc " +
                    "WHERE pt.period_number = ? " +
                    "AND pt.start_time = sc.lunch_start " +
                    "AND pt.end_time = sc.lunch_end";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, periodNumber);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= CHECK IF PERIOD IS SHORT BREAK =================
    public boolean isShortBreakPeriod(int periodNumber) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT pt.period_number " +
                    "FROM period_timings pt, system_config sc " +
                    "WHERE pt.period_number = ? " +
                    "AND pt.start_time = sc.short_break_start " +
                    "AND pt.end_time = sc.short_break_end " +
                    "AND sc.short_break_enabled = 1";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, periodNumber);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}