<%--&lt;%&ndash;--%>
<%--  Created by IntelliJ IDEA.--%>
<%--  User: Mohammed Adil--%>
<%--  Date: 12-02-2026--%>
<%--  Time: 06:55 pm--%>
<%--  To change this template use File | Settings | File Templates.--%>
<%--&ndash;%&gt;--%>


<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>

<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>Admin Dashboard</title>--%>

<%--    <link href="css/admin.css" rel="stylesheet">--%>
<%--</head>--%>

<%--<body>--%>

<%--<div class="container mt-4">--%>

<%--    <h2 class="text-center mb-4">Admin Configuration Panel</h2>--%>

<%--    <form>--%>

<%--        <!-- Number of Periods -->--%>
<%--        <div class="mb-3">--%>
<%--            <label class="form-label">Number of Periods per Day</label>--%>
<%--            <input type="number" class="form-control" name="periodCount" required>--%>
<%--        </div>--%>

<%--        <!-- Period Timings -->--%>
<%--        <h5 class="mt-4">Set Period Timings</h5>--%>

<%--        <div class="row">--%>
<%--            <div class="col-md-6">--%>
<%--                <label>Start Time</label>--%>
<%--                <input type="time" class="form-control" name="startTime">--%>
<%--            </div>--%>

<%--            <div class="col-md-6">--%>
<%--                <label>End Time</label>--%>
<%--                <input type="time" class="form-control" name="endTime">--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <!-- Working Days -->--%>
<%--        <h5 class="mt-4">Select Working Days</h5>--%>

<%--        <div class="form-check">--%>
<%--            <input type="checkbox" class="form-check-input" name="days" value="Monday">--%>
<%--            <label class="form-check-label">Monday</label>--%>
<%--        </div>--%>

<%--        <div class="form-check">--%>
<%--            <input type="checkbox" class="form-check-input" name="days" value="Tuesday">--%>
<%--            <label class="form-check-label">Tuesday</label>--%>
<%--        </div>--%>

<%--        <div class="form-check">--%>
<%--            <input type="checkbox" class="form-check-input" name="days" value="Wednesday">--%>
<%--            <label class="form-check-label">Wednesday</label>--%>
<%--        </div>--%>

<%--        <!-- Assign Subject to Faculty -->--%>
<%--        <h5 class="mt-4">Assign Subject to Faculty</h5>--%>

<%--        <div class="row">--%>
<%--            <div class="col-md-6">--%>
<%--                <input type="text" class="form-control" placeholder="Subject Name" name="subjectName">--%>
<%--            </div>--%>

<%--            <div class="col-md-6">--%>
<%--                <input type="text" class="form-control" placeholder="Faculty Name" name="facultyName">--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <!-- Batch Creation -->--%>
<%--        <h5 class="mt-4">Create Batch</h5>--%>

<%--        <div class="row">--%>
<%--            <div class="col-md-6">--%>
<%--                <input type="text" class="form-control" placeholder="Branch" name="branch">--%>
<%--            </div>--%>

<%--            <div class="col-md-6">--%>
<%--                <input type="text" class="form-control" placeholder="Division" name="division">--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <button class="btn btn-primary mt-4">Save Configuration</button>--%>

<%--    </form>--%>

<%--</div>--%>

<%--</body>--%>
<%--</html>--%>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.model.Faculty" %>
<%@ page import="com.college.model.Subject" %>
<%@ page import="com.college.model.Batch" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="css/admin.css" rel="stylesheet">
</head>

<body>

<div class="container">

    <h2>Admin Configuration Panel</h2>

    <!-- ================= SYSTEM CONFIGURATION ================= -->
    <div class="section">
        <h3>System Configuration</h3>

        <form action="saveConfig" method="post">

            <!-- ===== Period Count ===== -->
            <div class="form-group">
                <label>Number of Periods per Day</label><br>
                <input type="number" id="periodCount" name="periodCount" min="1" max="10" required>
            </div>

            <!-- ===== Dynamic Period Timings ===== -->
            <div class="form-group">
                <h4>Set Period Timings</h4>
                <div id="periodTimings"></div>
            </div>

            <!-- ===== Lunch Break ===== -->
            <div class="form-group">
                <h4>Lunch Break</h4>

                <label>Lunch Start</label>
                <input type="time" name="lunchStart" required>

                <label>Lunch End</label>
                <input type="time" name="lunchEnd" required>
            </div>

            <!-- ===== Short Break (Optional) ===== -->
            <div class="form-group">
                <h4>Short Break</h4>

                <label>
                    <input type="checkbox" id="shortBreakCheck" name="shortBreakEnabled">
                    Enable Short Break
                </label>

                <div id="shortBreakTimings" style="display:none; margin-top:10px;">
                    <label>Short Break Start</label>
                    <input type="time" name="shortBreakStart">

                    <label>Short Break End</label>
                    <input type="time" name="shortBreakEnd">
                </div>
            </div>

            <!-- ===== Working Days ===== -->
            <div class="form-group">
                <h3>Select Working Days</h3>

                <label><input type="checkbox" name="workingDays" value="Monday"> Monday</label><br>
                <label><input type="checkbox" name="workingDays" value="Tuesday"> Tuesday</label><br>
                <label><input type="checkbox" name="workingDays" value="Wednesday"> Wednesday</label><br>
                <label><input type="checkbox" name="workingDays" value="Thursday"> Thursday</label><br>
                <label><input type="checkbox" name="workingDays" value="Friday"> Friday</label><br>
                <label><input type="checkbox" name="workingDays" value="Saturday"> Saturday</label><br>
                <label><input type="checkbox" name="workingDays" value="Sunday"> Sunday</label><br>
            </div>

            <br>
            <button type="submit">Save Configuration</button>

        </form>
    </div>

    <!-- ================= ADD FACULTY ================= -->
    <div class="section">
        <h3>Add Faculty</h3>

        <form action="addFaculty" method="post">
            <input type="text" name="facultyName" placeholder="Faculty Name" required>
            <input type="text" name="department" placeholder="Department" required>
            <button type="submit">Add Faculty</button>
        </form>
    </div>


    <!-- ================= ADD SUBJECT ================= -->
    <div class="section">
        <h3>Add Subject</h3>

        <form action="addSubject" method="post">
            Subject Name: <input type="text" name="subjectName"><br>
            Subject Code: <input type="text" name="subjectCode"><br>
            Hours Per Week: <input type="number" name="hoursPerWeek"><br>
            Branch: <input type="text" name="branch"><br>
            Semester: <input type="number" name="semester"><br>
            <button type="submit">Add Subject</button>
        </form>
    </div>


    <!-- ================= ASSIGN SUBJECT ================= -->
    <div class="section">
        <h3>Assign Subject to Faculty</h3>

        <form action="assignSubject" method="post">

            <!-- Faculty Dropdown -->
            <label>Select Faculty:</label>
            <select name="facultyId" required>
                <%
                    List<com.college.model.Faculty> facultyList =
                            (List<com.college.model.Faculty>) request.getAttribute("facultyList");

                    if (facultyList != null) {
                        for (com.college.model.Faculty f : facultyList) {
                %>
                <option value="<%= f.getId() %>">
                    <%= f.getName() %>
                </option>
                <%
                        }
                    }
                %>
            </select>

            <br><br>

            <!-- Subject Dropdown -->
            <label>Select Subject:</label>
            <select name="subjectId" required>
                <%
                    List<com.college.model.Subject> subjectList =
                            (List<com.college.model.Subject>) request.getAttribute("subjectList");

                    if (subjectList != null) {
                        for (com.college.model.Subject s : subjectList) {
                %>
                <option value="<%= s.getId() %>">
                    <%= s.getSubjectName() %>
                </option>
                <%
                        }
                    }
                %>
            </select>

            <br><br>

            <button type="submit">Assign</button>
        </form>
    </div>


    <!-- ================= CREATE BATCH ================= -->
    <div class="section">
        <h3>Create Batch</h3>

        <form action="createBatch" method="post">

            Branch:
            <input type="text" name="branch">

            Division:
            <input type="text" name="division">

            Semester:
            <input type="number" name="semester">

            <button type="submit">Create Batch</button>

        </form>
    </div>

</div>

<!-- ================= GENERATE TIMETABLE ================= -->
<!-- ================= GENERATE TIMETABLE ================= -->
<form action="generateTimetable" method="post">

    <select name="batchId">

        <c:forEach var="b" items="${batches}">
            <option value="${b.id}">
                    ${b.branch} - Sem ${b.semester} - ${b.division}
            </option>
        </c:forEach>

    </select>

    <button type="submit">Generate Timetable</button>

</form>
<!-- ================= GENERATE TIMETABLE ================= -->
<%--<div class="section">--%>

<%--    <h3>Generate Timetable</h3>--%>

<%--    <form action="generateTimetable" method="post">--%>

<%--        <label>Select Batch:</label>--%>

<%--        <select name="batchId" required>--%>

<%--            <%--%>
<%--                List<com.college.model.Batch> batches =--%>
<%--                        (List<com.college.model.Batch>) request.getAttribute("batches");--%>

<%--                if (batches != null && !batches.isEmpty()) {--%>
<%--                    for (com.college.model.Batch b : batches) {--%>
<%--            %>--%>

<%--            <option value="<%= b.getId() %>">--%>
<%--                <%= b.getBranch() %> - Sem <%= b.getSemester() %> - <%= b.getDivision() %>--%>
<%--            </option>--%>

<%--            <%--%>
<%--                }--%>
<%--            } else {--%>
<%--            %>--%>

<%--            <option disabled>No batches found</option>--%>

<%--            <%--%>
<%--                }--%>
<%--            %>--%>

<%--        </select>--%>

<%--        <br><br>--%>

<%--        <button type="submit">Generate Timetable</button>--%>

<%--    </form>--%>

<%--</div>--%>

<!-- ================= JAVASCRIPT FOR DYNAMIC PERIODS ================= -->

<script>

    // ===== Dynamic Period Generator =====
    document.getElementById("periodCount").addEventListener("input", function () {

        let count = this.value;
        let container = document.getElementById("periodTimings");

        container.innerHTML = "";

        for (let i = 1; i <= count; i++) {

            let div = document.createElement("div");
            div.style.marginBottom = "8px";

            div.innerHTML =
                "<label>Period " + i + " Start</label> " +
                "<input type='time' name='p" + i + "Start' required> " +

                "<label> End</label> " +
                "<input type='time' name='p" + i + "End' required>";

            container.appendChild(div);
        }
    });


    // ===== Short Break Toggle =====
    document.getElementById("shortBreakCheck").addEventListener("change", function () {

        let shortBreakDiv = document.getElementById("shortBreakTimings");

        if (this.checked) {
            shortBreakDiv.style.display = "block";
        } else {
            shortBreakDiv.style.display = "none";
        }
    });

</script>
</body>
</html>
