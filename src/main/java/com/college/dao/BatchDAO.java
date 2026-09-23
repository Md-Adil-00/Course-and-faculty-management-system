package com.college.dao;

import com.college.model.Batch;
import com.college.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BatchDAO {

    // ================= ADD SINGLE BATCH =================
    public boolean addBatch(Batch batch) {

        String sql = "INSERT INTO batch (branch, division, semester) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, batch.getBranch());
            ps.setString(2, batch.getDivision());
            ps.setInt(3, batch.getSemester());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // ================= CREATE MULTIPLE BATCHES =================
    public void createBatches(String branch, int semester, int count) {

        String deleteSql = "DELETE FROM batch WHERE branch=? AND semester=?";
        String insertSql = "INSERT INTO batch (branch, division, semester) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement deletePs = conn.prepareStatement(deleteSql);
            deletePs.setString(1, branch);
            deletePs.setInt(2, semester);
            deletePs.executeUpdate();

            PreparedStatement insertPs = conn.prepareStatement(insertSql);

            for (int i = 0; i < count; i++) {

                char division = (char) ('A' + i);

                insertPs.setString(1, branch);
                insertPs.setString(2, String.valueOf(division));
                insertPs.setInt(3, semester);

                insertPs.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // ================= GET ALL BATCHES =================
    public List<Batch> getAllBatches() {

        List<Batch> list = new ArrayList<>();

        String sql = "SELECT id, branch, division, semester FROM batch ORDER BY branch, semester, division";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Batch batch = new Batch();

                batch.setId(rs.getInt("id"));
                batch.setBranch(rs.getString("branch"));
                batch.setDivision(rs.getString("division"));
                batch.setSemester(rs.getInt("semester"));

                list.add(batch);
            }

            System.out.println("Batches loaded: " + list.size());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ================= GET BATCH BY ID =================
    public Batch getBatchById(int id) {

        Batch batch = null;

        String sql = "SELECT id, branch, division, semester FROM batch WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                batch = new Batch();

                batch.setId(rs.getInt("id"));
                batch.setBranch(rs.getString("branch"));
                batch.setDivision(rs.getString("division"));
                batch.setSemester(rs.getInt("semester"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return batch;
    }


    // ================= GET BATCHES BY BRANCH =================
    public List<Batch> getBatchesByBranch(String branch) {

        List<Batch> list = new ArrayList<>();

        String sql = "SELECT id, branch, division, semester FROM batch WHERE branch=? ORDER BY semester, division";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, branch);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Batch batch = new Batch();

                batch.setId(rs.getInt("id"));
                batch.setBranch(rs.getString("branch"));
                batch.setDivision(rs.getString("division"));
                batch.setSemester(rs.getInt("semester"));

                list.add(batch);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ================= DELETE BATCH =================
    public void deleteBatch(int id) {

        String sql = "DELETE FROM batch WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // ================= DELETE BATCHES BY BRANCH =================
    public void deleteBatchesByBranch(String branch) {

        String sql = "DELETE FROM batch WHERE branch=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, branch);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}