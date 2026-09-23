package com.college.model;

public class Subject {

    private int id;
    private String subjectName;
    private String subjectCode;      // NEW
    private int hoursPerWeek;        // NEW
    private String branch;
    private int semester;

    private boolean isLab;

    public boolean isLab() {
        return isLab;
    }

    public void setLab(boolean lab) {
        isLab = lab;
    }

    // Empty constructor (important for servlet usage)
    public Subject() {}

    // Full constructor
    public Subject(int id, String subjectName, String subjectCode,
                   int hoursPerWeek, String branch, int semester) {
        this.id = id;
        this.subjectName = subjectName;
        this.subjectCode = subjectCode;
        this.hoursPerWeek = hoursPerWeek;
        this.branch = branch;
        this.semester = semester;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public int getHoursPerWeek() { return hoursPerWeek; }
    public void setHoursPerWeek(int hoursPerWeek) { this.hoursPerWeek = hoursPerWeek; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }
}