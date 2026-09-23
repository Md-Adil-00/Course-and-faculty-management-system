package com.college.dao;

import com.college.model.Subject;
import com.college.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    // ================= ADD SUBJECT =================
    public boolean addSubject(Subject subject) {

        String sql = "INSERT INTO subjects " +
                "(subject_name, subject_code, hours_per_week, branch, semester, is_lab) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, subject.getSubjectName());
            ps.setString(2, subject.getSubjectCode());
            ps.setInt(3, subject.getHoursPerWeek());
            ps.setString(4, subject.getBranch());
            ps.setInt(5, subject.getSemester());
            ps.setBoolean(6, subject.isLab());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= GET SUBJECTS BY BRANCH + SEM =================
    public List<Subject> getSubjectsByBranchAndSemester(String branch, int semester) {

        List<Subject> list = new ArrayList<>();

        String sql = "SELECT * FROM subjects WHERE branch = ? AND semester = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, branch);
            ps.setInt(2, semester);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    // ================= DELETE SUBJECT =================
    public boolean deleteSubject(int id) {
        String sql = "DELETE FROM subjects WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= GET ALL SUBJECTS =================
    public List<Subject> getAllSubjects() {

        List<Subject> subjectList = new ArrayList<>();
        String sql = "SELECT * FROM subjects";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                subjectList.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return subjectList;
    }
    // ================= MAPPER =================
    private Subject map(ResultSet rs) throws Exception {

        Subject s = new Subject();
        s.setId(rs.getInt("id"));
        s.setSubjectName(rs.getString("subject_name"));
        s.setSubjectCode(rs.getString("subject_code"));
        s.setHoursPerWeek(rs.getInt("hours_per_week"));
        s.setBranch(rs.getString("branch"));
        s.setSemester(rs.getInt("semester"));
        s.setLab(rs.getBoolean("is_lab"));

        return s;
    }
}