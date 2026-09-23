package com.college.dao;

import com.college.model.Faculty;
import com.college.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FacultyDAO {

    // INSERT FACULTY
    public boolean addFaculty(Faculty faculty) {

        String sql = "INSERT INTO faculty (name, department) VALUES (?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, faculty.getName());
            ps.setString(2, faculty.getDepartment());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // DELETE FACULTY
    public boolean deleteFaculty(int id) {
        String sql = "DELETE FROM faculty WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET ALL FACULTY
    public List<Faculty> getAllFaculty() {

        List<Faculty> facultyList = new ArrayList<>();
        String sql = "SELECT * FROM faculty";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Faculty faculty = new Faculty();
                faculty.setId(rs.getInt("id"));
                faculty.setName(rs.getString("name"));
                faculty.setDepartment(rs.getString("department"));

                facultyList.add(faculty);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return facultyList;
    }
}