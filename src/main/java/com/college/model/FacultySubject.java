package com.college.model;

public class FacultySubject {

    private int id;
    private int facultyId;
    private int subjectId;

    public FacultySubject() {}

    public FacultySubject(int id, int facultyId, int subjectId) {
        this.id = id;
        this.facultyId = facultyId;
        this.subjectId = subjectId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getFacultyId() { return facultyId; }
    public void setFacultyId(int facultyId) { this.facultyId = facultyId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
}