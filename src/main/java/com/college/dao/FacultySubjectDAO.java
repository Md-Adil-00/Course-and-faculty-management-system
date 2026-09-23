package com.college.dao;

import com.college.util.DBConnection;
import java.sql.*;
import java.util.*;

public class FacultySubjectDAO {

    public List<Integer> getFacultyBySubject(int subjectId) {

        List<Integer> facultyIds = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT faculty_id FROM faculty_subject WHERE subject_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, subjectId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                facultyIds.add(rs.getInt("faculty_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return facultyIds;
    }

    // ================= GET ALL ASSIGNMENTS (faculty + subject details) =================
    public List<Map<String, String>> getAllAssignments() {

        List<Map<String, String>> list = new ArrayList<>();

        String sql = "SELECT fs.faculty_id, fs.subject_id, " +
                "f.name AS faculty_name, f.department, " +
                "s.subject_name, s.subject_code, s.branch, s.semester, s.is_lab " +
                "FROM faculty_subject fs " +
                "JOIN faculty f ON fs.faculty_id = f.id " +
                "JOIN subjects s ON fs.subject_id = s.id " +
                "ORDER BY f.name, s.subject_name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("facultyId",    String.valueOf(rs.getInt("faculty_id")));
                row.put("subjectId",    String.valueOf(rs.getInt("subject_id")));
                row.put("facultyName",  rs.getString("faculty_name"));
                row.put("department",   rs.getString("department"));
                row.put("subjectName",  rs.getString("subject_name"));
                row.put("subjectCode",  rs.getString("subject_code") != null ? rs.getString("subject_code") : "");
                row.put("branch",       rs.getString("branch").toUpperCase());
                row.put("semester",     String.valueOf(rs.getInt("semester")));
                row.put("isLab",        String.valueOf(rs.getBoolean("is_lab")));
                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}