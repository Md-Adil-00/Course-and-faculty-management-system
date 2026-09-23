package com.college.model;

public class Batch {

    private int id;
    private String branch;
    private String division;
    private int semester;   // NEW FIELD

    public Batch() {}

    public Batch(int id, String branch, String division, int semester) {
        this.id = id;
        this.branch = branch;
        this.division = division;
        this.semester = semester;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBranch() {
        return branch;
    }

    public void setBranch(String branch) {
        this.branch = branch;
    }

    public String getDivision() {
        return division;
    }

    public void setDivision(String division) {
        this.division = division;
    }

    // NEW GETTER
    public int getSemester() {
        return semester;
    }

    // NEW SETTER
    public void setSemester(int semester) {
        this.semester = semester;
    }
}