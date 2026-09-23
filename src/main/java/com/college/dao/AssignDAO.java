package com.college.dao;

import com.college.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AssignDAO {

    // ================= ASSIGN FACULTY TO SUBJECT =================
    public void assignSubject(int facultyId, int subjectId) {

        String sql = "INSERT INTO faculty_subject (faculty_id, subject_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, facultyId);
            ps.setInt(2, subjectId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= CHECK IF ALREADY ASSIGNED =================
    // Prevents duplicate entries in faculty_subject table
    public boolean isAlreadyAssigned(int facultyId, int subjectId) {

        String sql = "SELECT COUNT(*) FROM faculty_subject WHERE faculty_id=? AND subject_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, facultyId);
            ps.setInt(2, subjectId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= DELETE ASSIGNMENT =================
    public void deleteAssignment(int facultyId, int subjectId) {

        String sql = "DELETE FROM faculty_subject WHERE faculty_id=? AND subject_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, facultyId);
            ps.setInt(2, subjectId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}