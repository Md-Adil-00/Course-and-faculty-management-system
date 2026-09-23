<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.college.model.Faculty" %>
<%@ page import="com.college.model.Subject" %>
<%@ page import="com.college.model.Batch" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #f4f6fb; --surface: #ffffff; --border: #e2e8f0;
            --accent: #2563eb; --accent2: #1e4fd8; --green: #16a34a;
            --yellow: #d97706; --red: #dc2626; --text: #0f172a;
            --muted: #64748b; --light: #f8fafc;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        /* TOPBAR */
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 0 40px; display: flex; align-items: center; justify-content: space-between; height: 58px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100; }
        .topbar-logo { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 18px; color: var(--text); letter-spacing: -0.5px; }
        .topbar-logo span { color: var(--accent); }
        .topbar-right { display: flex; align-items: center; gap: 10px; }
        .role-badge { background: #eff6ff; color: var(--accent); border: 1px solid #bfdbfe; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .btn-view { background: var(--accent); color: white; text-decoration: none; padding: 7px 16px; border-radius: 7px; font-size: 13px; font-weight: 600; transition: background 0.2s; }
        .btn-view:hover { background: var(--accent2); }

        /* LAYOUT */
        .page-wrapper { max-width: 900px; margin: 0 auto; padding: 36px 24px 60px; }
        .page-title { font-family: 'Syne', sans-serif; font-size: 26px; font-weight: 800; letter-spacing: -0.5px; margin-bottom: 4px; }
        .page-subtitle { color: var(--muted); font-size: 14px; margin-bottom: 32px; }

        /* SECTION CARDS */
        .section { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 28px 30px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
        .section-header { display: flex; align-items: center; gap: 12px; margin-bottom: 22px; padding-bottom: 16px; border-bottom: 1px solid var(--border); }
        .section-icon { width: 38px; height: 38px; border-radius: 10px; background: #eff6ff; border: 1px solid #bfdbfe; display: flex; align-items: center; justify-content: center; font-size: 17px; flex-shrink: 0; }
        .section-icon.green  { background: #f0fdf4; border-color: #bbf7d0; }
        .section-icon.yellow { background: #fffbeb; border-color: #fde68a; }
        .section-icon.purple { background: #f5f3ff; border-color: #ddd6fe; }
        .section-icon.red    { background: #fef2f2; border-color: #fecaca; }
        .section h3 { font-family: 'Syne', sans-serif; font-size: 16px; font-weight: 700; color: var(--text); margin: 0; }
        .section-desc { font-size: 12px; color: var(--muted); margin-top: 2px; }

        /* FORM ELEMENTS */
        .form-grid   { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 14px; }
        .form-group  { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }

        label { font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.7px; }

        input[type="text"], input[type="number"], input[type="time"] {
            background: var(--light); border: 1px solid var(--border); color: var(--text);
            padding: 10px 13px; border-radius: 8px; font-size: 14px; font-family: inherit;
            outline: none; transition: border-color 0.2s, box-shadow 0.2s; width: 100%;
        }
        input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(37,99,235,0.08); }
        input[type="time"] { width: auto; min-width: 130px; }

        select {
            background: var(--light); border: 1px solid var(--border); color: var(--text);
            padding: 10px 13px; border-radius: 8px; font-size: 14px; font-family: inherit;
            outline: none; transition: border-color 0.2s; width: 100%;
            -webkit-appearance: none; cursor: pointer;
        }
        select:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(37,99,235,0.08); }

        /* CHECKBOXES */
        .checkbox-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; margin-top: 4px; }
        .day-checkbox { display: flex; align-items: center; gap: 8px; background: var(--light); border: 1px solid var(--border); border-radius: 8px; padding: 9px 12px; cursor: pointer; transition: all 0.15s; font-size: 13px; font-weight: 500; color: var(--text); user-select: none; }
        .day-checkbox:hover { border-color: var(--accent); background: #eff6ff; }
        .day-checkbox input[type="checkbox"] { width: 15px; height: 15px; accent-color: var(--accent); cursor: pointer; flex-shrink: 0; }

        .toggle-label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px; font-weight: 500; color: var(--text); text-transform: none; letter-spacing: 0; }
        .toggle-label input[type="checkbox"] { width: 16px; height: 16px; accent-color: var(--accent); }

        /* PERIOD TIMINGS */
        #periodTimings { display: flex; flex-direction: column; gap: 10px; margin-top: 8px; }
        #periodTimings .period-row { display: flex; align-items: center; gap: 16px; background: var(--light); padding: 12px 16px; border-radius: 10px; border: 1px solid var(--border); flex-wrap: wrap; }
        #periodTimings .period-row label { font-size: 13px; font-weight: 600; color: var(--text); text-transform: none; letter-spacing: 0; min-width: 65px; }

        #shortBreakTimings { background: var(--light); border: 1px solid var(--border); border-radius: 10px; padding: 16px; margin-top: 12px; display: flex; gap: 20px; flex-wrap: wrap; align-items: center; }
        #shortBreakTimings label { text-transform: none; letter-spacing: 0; font-size: 13px; font-weight: 500; color: var(--muted); }

        /* BUTTONS */
        button[type="submit"]:not(.btn-remove) { background: var(--accent); color: white; padding: 10px 22px; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; font-family: inherit; transition: all 0.2s; margin-top: 18px; display: inline-flex; align-items: center; gap: 7px; }
        button[type="submit"]:not(.btn-remove):hover { background: var(--accent2); transform: translateY(-1px); }
        .btn-green { background: var(--green) !important; }
        .btn-green:hover { background: #15803d !important; }

        /* HINT */
        .hint { font-size: 12px; color: var(--muted); margin-top: 6px; display: block; }

        /* CHIPS */
        .chip-list { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 14px; }
        .chip { background: var(--light); border: 1px solid var(--border); border-radius: 8px; padding: 7px 13px; font-size: 13px; }
        .tag { display: inline-block; font-size: 10px; font-weight: 700; padding: 1px 6px; border-radius: 4px; margin-left: 5px; }
        .tag-blue   { background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; }
        .tag-green  { background: #dcfce7; color: #16a34a; }
        .tag-purple { background: #f5f3ff; color: #7c3aed; border: 1px solid #ddd6fe; }
        .tag-yellow { background: #fffbeb; color: #d97706; border: 1px solid #fde68a; }

        .divider { border-top: 1px solid var(--border); padding-top: 18px; margin-top: 22px; }
        .existing-label { font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.7px; margin-bottom: 12px; display: block; }

        /* REMOVE BUTTON */
        .btn-remove { background: none; border: none; color: #cbd5e1; padding: 2px 5px; border-radius: 4px; font-size: 12px; font-weight: 600; cursor: pointer; font-family: inherit; transition: all 0.15s; flex-shrink: 0; line-height: 1; }
        .btn-remove:hover { background: #fef2f2; color: var(--red); }
        .chip { background: var(--light); border: 1px solid var(--border); border-radius: 8px; padding: 7px 10px 7px 13px; font-size: 13px; display: flex; align-items: center; gap: 8px; justify-content: space-between; }
        .chip-text { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
        .id-badge { display: inline-block; background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; font-size: 10px; font-weight: 700; padding: 1px 7px; border-radius: 4px; font-family: monospace; }

        /* RESPONSIVE */
        @media (max-width: 640px) {
            .topbar { padding: 0 20px; }
            .page-wrapper { padding: 20px 16px; }
            .form-grid, .form-grid-3 { grid-template-columns: 1fr; }
            .checkbox-grid { grid-template-columns: repeat(2, 1fr); }
            .section { padding: 20px; }
        }
    </style>
</head>
<body>

<%
    List<Faculty> facultyList = (List<Faculty>) request.getAttribute("facultyList");
    List<Subject> subjectList = (List<Subject>) request.getAttribute("subjectList");
    List<Batch>   batches     = (List<Batch>)   request.getAttribute("batches");
    List<Map<String, String>> assignments = (List<Map<String, String>>) request.getAttribute("assignments");
%>

<!-- TOPBAR -->
<div class="topbar">
    <div class="topbar-logo">En<span>Coder</span></div>
    <div class="topbar-right">
        <span class="role-badge">Admin Panel</span>
        <a href="viewTimetable" class="btn-view">&#128198; View Timetables</a>
    </div>
</div>

<div class="page-wrapper">
    <div class="page-title">Admin Configuration</div>
    <div class="page-subtitle">Manage system settings, faculty, subjects, batches and timetable generation</div>

    <!-- ===== SYSTEM CONFIGURATION ===== -->
    <div class="section">
        <div class="section-header">
            <div class="section-icon">&#9881;</div>
            <div>
                <h3>System Configuration</h3>
                <div class="section-desc">Set period count, timings, breaks and working days</div>
            </div>
        </div>
        <form action="saveConfig" method="post">
            <div class="form-grid">
                <div class="form-group">
                    <label>Number of Periods per Day</label>
                    <input type="number" id="periodCount" name="periodCount" min="1" max="12" placeholder="e.g. 6" required>
                </div>
            </div>

            <div class="form-group" style="margin-top:20px;">
                <label>Period Timings</label>
                <div id="periodTimings"></div>
                <span class="hint">&#8593; Enter number of periods above to set their timings</span>
            </div>

            <div style="margin-top:20px;">
                <label style="margin-bottom:10px; display:block;">Lunch Break</label>
                <div style="display:flex; gap:20px; flex-wrap:wrap;">
                    <div class="form-group" style="margin:0;">
                        <label>Start Time</label>
                        <input type="time" name="lunchStart" required>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>End Time</label>
                        <input type="time" name="lunchEnd" required>
                    </div>
                </div>
            </div>

            <div class="form-group" style="margin-top:20px;">
                <label class="toggle-label">
                    <input type="checkbox" id="shortBreakCheck" name="shortBreakEnabled">
                    Enable Short Break
                </label>
                <div id="shortBreakTimings" style="display:none;">
                    <div class="form-group" style="margin:0;">
                        <label>Start Time</label>
                        <input type="time" name="shortBreakStart">
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>End Time</label>
                        <input type="time" name="shortBreakEnd">
                    </div>
                </div>
            </div>

            <div class="form-group" style="margin-top:20px;">
                <label>Working Days</label>
                <div class="checkbox-grid">
                    <label class="day-checkbox"><input type="checkbox" name="workingDays" value="Monday"> Monday</label>
                    <label class="day-checkbox"><input type="checkbox" name="workingDays" value="Tuesday"> Tuesday</label>
                    <label class="day-checkbox"><input type="checkbox" name="workingDays" value="Wednesday"> Wednesday</label>
                    <label class="day-checkbox"><input type="checkbox" name="workingDays" value="Thursday"> Thursday</label>
                    <label class="day-checkbox"><input type="checkbox" name="workingDays" value="Friday"> Friday</label>
                    <label class="day-checkbox"><input type="checkbox" name="workingDays" value="Saturday"> Saturday</label>
                    <label class="day-checkbox"><input type="checkbox" name="workingDays" value="Sunday"> Sunday</label>
                </div>
            </div>

            <button type="submit">&#10003; Save Configuration</button>
        </form>
    </div>

    <!-- ===== ADD FACULTY ===== -->
    <div class="section">
        <div class="section-header">
            <div class="section-icon green">&#128100;</div>
            <div>
                <h3>Add Faculty</h3>
                <div class="section-desc">Register a new faculty member</div>
            </div>
        </div>
        <form action="addFaculty" method="post">
            <div class="form-grid">
                <div class="form-group">
                    <label>Faculty Name</label>
                    <input type="text" name="facultyName" placeholder="e.g. Dr. John Smith" required>
                </div>
                <div class="form-group">
                    <label>Department</label>
                    <input type="text" name="department" placeholder="e.g. Computer Science" required>
                </div>
            </div>
            <button type="submit">&#43; Add Faculty</button>
        </form>
        <% if (facultyList != null && !facultyList.isEmpty()) { %>
        <div class="divider">
            <span class="existing-label">Existing Faculty (<%= facultyList.size() %>)</span>
            <div class="chip-list">
                <% for (Faculty f : facultyList) { %>
                <div class="chip">
                    <div class="chip-text">
                        <span class="id-badge">#<%= f.getId() %></span>
                        <strong><%= f.getName() %></strong>
                        <span style="color:var(--muted);"><%= f.getDepartment() %></span>
                    </div>
                    <form action="deleteFaculty" method="post" style="margin:0;"
                          onsubmit="return confirm('Remove <%= f.getName().replace("'","\'") %>? This may affect assigned subjects and timetable.')">
                        <input type="hidden" name="facultyId" value="<%= f.getId() %>">
                        <button type="submit" class="btn-remove">✕ Remove</button>
                    </form>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>

    <!-- ===== ADD SUBJECT ===== -->
    <div class="section">
        <div class="section-header">
            <div class="section-icon yellow">&#128218;</div>
            <div>
                <h3>Add Subject</h3>
                <div class="section-desc">Add a subject for a specific branch and semester</div>
            </div>
        </div>
        <form action="addSubject" method="post">
            <div class="form-grid">
                <div class="form-group">
                    <label>Subject Name</label>
                    <input type="text" name="subjectName" placeholder="e.g. Data Structures" required>
                </div>
                <div class="form-group">
                    <label>Subject Code</label>
                    <input type="text" name="subjectCode" placeholder="e.g. CS301">
                </div>
                <div class="form-group">
                    <label>Branch</label>
                    <input type="text" name="branch" placeholder="e.g. cse" required>
                </div>
                <div class="form-group">
                    <label>Semester</label>
                    <input type="number" name="semester" min="1" max="8" placeholder="e.g. 3" required>
                </div>
                <div class="form-group">
                    <label>Hours Per Week</label>
                    <input type="number" name="hoursPerWeek" min="1" placeholder="e.g. 4" required>
                </div>
                <div class="form-group" style="justify-content:flex-end;">
                    <label>Type</label>
                    <label class="toggle-label" style="margin-top:6px;">
                        <input type="checkbox" name="isLab"> Is Lab Subject
                    </label>
                </div>
            </div>
            <button type="submit">&#43; Add Subject</button>
        </form>
        <% if (subjectList != null && !subjectList.isEmpty()) { %>
        <div class="divider">
            <span class="existing-label">Existing Subjects (<%= subjectList.size() %>)</span>
            <div class="chip-list">
                <% for (Subject s : subjectList) { %>
                <div class="chip">
                    <div class="chip-text">
                        <span class="id-badge">#<%= s.getId() %></span>
                        <strong><%= s.getSubjectName() %></strong>
                        <% if (s.getSubjectCode() != null && !s.getSubjectCode().isEmpty()) { %><span class="tag tag-blue"><%= s.getSubjectCode() %></span><% } %>
                        <% if (s.isLab()) { %><span class="tag tag-green">LAB</span><% } %>
                        <span style="color:var(--muted); font-size:12px;"><%= s.getBranch().toUpperCase() %> &middot; Sem <%= s.getSemester() %> &middot; <%= s.getHoursPerWeek() %>h/wk</span>
                    </div>
                    <form action="deleteSubject" method="post" style="margin:0;"
                          onsubmit="return confirm('Remove <%= s.getSubjectName().replace("'","\'") %>? This will also remove related assignments.')">
                        <input type="hidden" name="subjectId" value="<%= s.getId() %>">
                        <button type="submit" class="btn-remove">✕ Remove</button>
                    </form>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>

    <!-- ===== ASSIGN SUBJECT TO FACULTY ===== -->
    <div class="section">
        <div class="section-header">
            <div class="section-icon purple">&#128279;</div>
            <div>
                <h3>Assign Subject to Faculty</h3>
                <div class="section-desc">Link a faculty member to the subject they will teach</div>
            </div>
        </div>
        <form action="assignSubject" method="post">
            <div class="form-grid">
                <div class="form-group">
                    <label>Select Faculty</label>
                    <select name="facultyId" required>
                        <option value="">-- Choose Faculty --</option>
                        <% if (facultyList != null) { for (Faculty f : facultyList) { %>
                        <option value="<%= f.getId() %>"><%= f.getName() %> — #<%= f.getId() %> &mdash; <%= f.getDepartment() %></option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Select Subject</label>
                    <select name="subjectId" required>
                        <option value="">-- Choose Subject --</option>
                        <% if (subjectList != null) { for (Subject s : subjectList) { %>
                        <option value="<%= s.getId() %>"><%= s.getSubjectName() %> (<%= s.getBranch().toUpperCase() %> Sem <%= s.getSemester() %><%= s.isLab() ? " · LAB" : "" %>)</option>
                        <% } } %>
                    </select>
                </div>
            </div>
            <button type="submit">&#128279; Assign</button>
        </form>

        <% if (assignments != null && !assignments.isEmpty()) { %>
        <div class="divider">
            <span class="existing-label">Current Assignments (<%= assignments.size() %>)</span>
            <div class="chip-list">
                <% for (Map<String, String> a : assignments) { %>
                <div class="chip">
                    <div class="chip-text">
                        <span class="id-badge">#<%= a.get("facultyId") %></span>
                        <strong><%= a.get("facultyName") %></strong>
                        <span style="color:var(--muted); font-size:12px;">→</span>
                        <span><%= a.get("subjectName") %></span>
                        <% if (!a.get("subjectCode").isEmpty()) { %><span class="tag tag-blue"><%= a.get("subjectCode") %></span><% } %>
                        <% if ("true".equals(a.get("isLab"))) { %><span class="tag tag-green">LAB</span><% } %>
                        <span class="tag tag-purple"><%= a.get("branch") %> Sem <%= a.get("semester") %></span>
                    </div>
                    <form action="deleteAssignment" method="post" style="margin:0;"
                          onsubmit="return confirm('Remove this assignment?')">
                        <input type="hidden" name="facultyId" value="<%= a.get("facultyId") %>">
                        <input type="hidden" name="subjectId" value="<%= a.get("subjectId") %>">
                        <button type="submit" class="btn-remove">✕ Remove</button>
                    </form>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>

    <!-- ===== CREATE BATCH ===== -->
    <div class="section">
        <div class="section-header">
            <div class="section-icon green">&#127979;</div>
            <div>
                <h3>Create Batch</h3>
                <div class="section-desc">Creates Div A, B, C... automatically based on number entered</div>
            </div>
        </div>
        <form action="createBatch" method="post">
            <div class="form-grid-3">
                <div class="form-group">
                    <label>Branch</label>
                    <input type="text" name="branch" placeholder="e.g. cse" required>
                </div>
                <div class="form-group">
                    <label>Semester</label>
                    <input type="number" name="semester" min="1" max="8" placeholder="e.g. 3" required>
                </div>
                <div class="form-group">
                    <label>No. of Divisions</label>
                    <input type="number" name="divisions" min="1" max="10" placeholder="e.g. 3" required>
                </div>
            </div>
            <button type="submit">&#43; Create Batches</button>
        </form>
        <% if (batches != null && !batches.isEmpty()) { %>
        <div class="divider">
            <span class="existing-label">Existing Batches (<%= batches.size() %>)</span>
            <div class="chip-list">
                <% for (Batch b : batches) { %>
                <div class="chip">
                    <strong><%= b.getBranch().toUpperCase() %></strong>
                    <span class="tag tag-purple">Sem <%= b.getSemester() %></span>
                    <span class="tag tag-yellow">Div <%= b.getDivision() %></span>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>

    <!-- ===== GENERATE TIMETABLE ===== -->
    <div class="section">
        <div class="section-header">
            <div class="section-icon red">&#9889;</div>
            <div>
                <h3>Generate Timetable</h3>
                <div class="section-desc">Generates timetables for all batches. Faculty clashes are automatically prevented.</div>
            </div>
        </div>
        <form action="generateTimetable" method="post">
            <button type="submit" class="btn-green">&#9889; Generate All Timetables</button>
        </form>
    </div>

</div>

<script>
    document.getElementById("periodCount").addEventListener("input", function () {
        let count = parseInt(this.value) || 0;
        let container = document.getElementById("periodTimings");
        container.innerHTML = "";
        for (let i = 1; i <= count; i++) {
            let div = document.createElement("div");
            div.className = "period-row";
            div.innerHTML =
                '<label>Period ' + i + '</label>' +
                '<div style="display:flex;gap:16px;flex-wrap:wrap;">' +
                '<div class="form-group" style="margin:0;"><label>Start</label><input type="time" name="p' + i + 'Start" required></div>' +
                '<div class="form-group" style="margin:0;"><label>End</label><input type="time" name="p' + i + 'End" required></div>' +
                '</div>';
            container.appendChild(div);
        }
    });

    document.getElementById("shortBreakCheck").addEventListener("change", function () {
        document.getElementById("shortBreakTimings").style.display = this.checked ? "flex" : "none";
    });
</script>
</body>
</html>
