package com.college.dao;

import com.college.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TimetableDAO {

    // ================= GET FULL TIMETABLE FOR BATCH =================
    public java.util.List<java.util.Map<String, String>> getTimetableForBatch(int batchId) {

        java.util.List<java.util.Map<String, String>> rows = new java.util.ArrayList<>();

        String sql =
                "SELECT t.day_name, t.period_number, " +
                        "s.subject_name, s.is_lab, f.name AS faculty_name " +
                        "FROM timetable t " +
                        "JOIN subjects s ON t.subject_id = s.id " +
                        "JOIN faculty f ON t.faculty_id = f.id " +
                        "WHERE t.batch_id = ? " +
                        "ORDER BY FIELD(t.day_name,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), " +
                        "t.period_number";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                java.util.Map<String, String> row = new java.util.LinkedHashMap<>();
                row.put("day",         rs.getString("day_name"));
                row.put("period",      String.valueOf(rs.getInt("period_number")));
                row.put("subject",     rs.getString("subject_name"));
                row.put("isLab",       String.valueOf(rs.getBoolean("is_lab")));
                row.put("faculty",     rs.getString("faculty_name"));
                rows.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rows;
    }


    // ================= DELETE OLD TIMETABLE =================
    public void deleteByBatch(int batchId) {

        String sql = "DELETE FROM timetable WHERE batch_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // ================= INSERT SLOT =================
    public void insertSlot(int batchId,
                           String day,
                           int period,
                           int subjectId,
                           int facultyId) {

        String sql =
                "INSERT INTO timetable (day_name, period_number, subject_id, faculty_id, batch_id) " +
                        "VALUES (?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, day);
            ps.setInt(2, period);
            ps.setInt(3, subjectId);
            ps.setInt(4, facultyId);
            ps.setInt(5, batchId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // ================= CHECK BATCH SLOT FREE =================
    public boolean isBatchSlotFree(int batchId, String day, int period) {

        String sql =
                "SELECT COUNT(*) FROM timetable WHERE batch_id=? AND day_name=? AND period_number=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ps.setString(2, day);
            ps.setInt(3, period);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) == 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // ================= CHECK FACULTY FREE =================
    public boolean isFacultyFree(int facultyId, String day, int period) {

        String sql =
                "SELECT COUNT(*) FROM timetable WHERE faculty_id=? AND day_name=? AND period_number=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, facultyId);
            ps.setString(2, day);
            ps.setInt(3, period);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) == 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // ================= CHECK CONTINUOUS SLOT (LAB SUPPORT) =================
    public boolean isContinuousSlotFree(int batchId,
                                        int facultyId,
                                        String day,
                                        int period) {

        return isBatchSlotFree(batchId, day, period)
                && isBatchSlotFree(batchId, day, period + 1)
                && isFacultyFree(facultyId, day, period)
                && isFacultyFree(facultyId, day, period + 1);
    }


    // ================= COUNT SUBJECT IN A DAY =================
    public int countSubjectInDay(int batchId,
                                 String day,
                                 int subjectId) {

        String sql =
                "SELECT COUNT(*) FROM timetable WHERE batch_id=? AND day_name=? AND subject_id=?";

        int count = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ps.setString(2, day);
            ps.setInt(3, subjectId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }


    // ================= GET SUBJECT AT A SPECIFIC SLOT =================
    public int getSubjectAtSlot(int batchId, String day, int period) {

        String sql =
                "SELECT subject_id FROM timetable WHERE batch_id=? AND day_name=? AND period_number=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ps.setString(2, day);
            ps.setInt(3, period);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("subject_id");

        } catch (Exception e) {
            // period may be out of range (0 or negative) - that is fine, return -1
        }

        return -1;
    }


    // ================= GET FACULTY-SUBJECT LIST FOR A BATCH =================
    // Returns distinct subject + faculty pairs for a given batch (for student view)
    public java.util.List<java.util.Map<String, String>> getFacultySubjectListForBatch(int batchId) {

        java.util.List<java.util.Map<String, String>> list = new java.util.ArrayList<>();

        String sql =
                "SELECT DISTINCT s.subject_name, s.subject_code, s.is_lab, f.name AS faculty_name, f.department " +
                        "FROM timetable t " +
                        "JOIN subjects s ON t.subject_id = s.id " +
                        "JOIN faculty  f ON t.faculty_id = f.id " +
                        "WHERE t.batch_id = ? " +
                        "ORDER BY s.subject_name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                java.util.Map<String, String> row = new java.util.LinkedHashMap<>();
                row.put("subjectName", rs.getString("subject_name"));
                row.put("subjectCode", rs.getString("subject_code") != null ? rs.getString("subject_code") : "");
                row.put("isLab",       String.valueOf(rs.getBoolean("is_lab")));
                row.put("facultyName", rs.getString("faculty_name"));
                row.put("department",  rs.getString("department"));
                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ================= GET FACULTY SCHEDULE FOR A SPECIFIC DAY =================
    // Returns each period the faculty teaches today, joined with subject, batch and period timings
    public java.util.List<java.util.Map<String, String>> getFacultyDaySchedule(int facultyId, String day) {

        java.util.List<java.util.Map<String, String>> list = new java.util.ArrayList<>();

        String sql =
                "SELECT t.period_number, s.subject_name, s.is_lab, " +
                        "b.branch, b.division, b.semester, " +
                        "pt.start_time, pt.end_time " +
                        "FROM timetable t " +
                        "JOIN subjects s        ON t.subject_id  = s.id " +
                        "JOIN batch b           ON t.batch_id    = b.id " +
                        "LEFT JOIN period_timings pt ON t.period_number = pt.period_number " +
                        "WHERE t.faculty_id = ? AND t.day_name = ? " +
                        "ORDER BY t.period_number";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, facultyId);
            ps.setString(2, day);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                java.util.Map<String, String> row = new java.util.LinkedHashMap<>();
                row.put("period",      String.valueOf(rs.getInt("period_number")));
                row.put("subject",     rs.getString("subject_name"));
                row.put("isLab",       String.valueOf(rs.getBoolean("is_lab")));
                row.put("branch",      rs.getString("branch").toUpperCase());
                row.put("division",    rs.getString("division"));
                row.put("semester",    String.valueOf(rs.getInt("semester")));

                // Store both 12hr (display) and raw (duration calc)
                String rawStart = rs.getString("start_time");
                String rawEnd   = rs.getString("end_time");
                row.put("startTime",   to12hr(rawStart));
                row.put("endTime",     to12hr(rawEnd));
                row.put("startTime24", rawStart != null ? rawStart.substring(0, Math.min(5, rawStart.length())) : "");
                row.put("endTime24",   rawEnd   != null ? rawEnd.substring(0, Math.min(5, rawEnd.length()))     : "");
                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ================= GET FACULTY FULL WEEK SCHEDULE =================
    // Returns all slots for a faculty across all days, ordered by day then period
    public java.util.List<java.util.Map<String, String>> getFacultyWeekSchedule(int facultyId) {

        java.util.List<java.util.Map<String, String>> list = new java.util.ArrayList<>();

        String sql =
                "SELECT t.day_name, t.period_number, s.subject_name, s.is_lab, " +
                        "b.branch, b.division, b.semester " +
                        "FROM timetable t " +
                        "JOIN subjects s ON t.subject_id = s.id " +
                        "JOIN batch b    ON t.batch_id   = b.id " +
                        "WHERE t.faculty_id = ? " +
                        "ORDER BY FIELD(t.day_name,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), " +
                        "t.period_number";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, facultyId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                java.util.Map<String, String> row = new java.util.LinkedHashMap<>();
                row.put("day",      rs.getString("day_name"));
                row.put("period",   String.valueOf(rs.getInt("period_number")));
                row.put("subject",  rs.getString("subject_name"));
                row.put("isLab",    String.valueOf(rs.getBoolean("is_lab")));
                row.put("branch",   rs.getString("branch").toUpperCase());
                row.put("division", rs.getString("division"));
                row.put("semester", String.valueOf(rs.getInt("semester")));
                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ── Convert HH:mm or HH:mm:ss → 12-hour format ──────────────────────────
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


    // ================= NEW METHOD FOR GENERATOR =================
    public int countSubjectForBatchOnDay(int batchId,
                                         int subjectId,
                                         String day) {

        String sql =
                "SELECT COUNT(*) FROM timetable WHERE batch_id=? AND subject_id=? AND day_name=?";

        int count = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ps.setInt(2, subjectId);
            ps.setString(3, day);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
}