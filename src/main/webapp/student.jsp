<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.college.model.Batch" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Timetable</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #f4f6fb; --surface: #ffffff; --card: #ffffff; --border: #e2e8f0;
            --accent: #7c3aed; --accent2: #6d28d9; --green: #16a34a; --yellow: #d97706;
            --blue: #2563eb; --text: #0f172a; --muted: #64748b; --light: #f8fafc;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        /* TOPBAR */
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 0 40px; display: flex; align-items: center; justify-content: space-between; height: 58px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .topbar-logo { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 18px; color: var(--text); }
        .topbar-logo span { color: var(--accent); }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .role-badge { background: #f5f3ff; color: var(--accent); border: 1px solid #ddd6fe; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .btn-link { color: var(--muted); font-size: 13px; text-decoration: none; padding: 6px 14px; border: 1px solid var(--border); border-radius: 6px; transition: all 0.2s; }
        .btn-link:hover { color: var(--text); border-color: #94a3b8; }

        /* LAYOUT */
        .layout { display: flex; min-height: calc(100vh - 58px); }

        /* SIDEBAR */
        .sidebar { width: 280px; background: var(--surface); border-right: 1px solid var(--border); flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar-header { padding: 20px 16px 14px; border-bottom: 1px solid var(--border); }
        .sidebar-header h2 { font-family: 'Syne', sans-serif; font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 12px; }
        .search-input { width: 100%; background: var(--light); border: 1px solid var(--border); color: var(--text); padding: 9px 13px; border-radius: 8px; font-size: 13px; font-family: 'DM Sans', sans-serif; outline: none; }
        .search-input::placeholder { color: #94a3b8; }
        .search-input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(124,58,237,0.08); }

        .batch-list { flex: 1; overflow-y: auto; padding: 8px; }
        .batch-group { margin-bottom: 6px; }
        .batch-group-label { font-size: 10px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 1px; padding: 8px 12px 4px; }
        .batch-item { display: flex; align-items: center; gap: 11px; padding: 10px 12px; border-radius: 9px; cursor: pointer; transition: all 0.15s; text-decoration: none; margin-bottom: 2px; border: 1px solid transparent; }
        .batch-item:hover { background: var(--light); }
        .batch-item.active { background: #f5f3ff; border-color: #ddd6fe; }
        .batch-avatar { width: 34px; height: 34px; border-radius: 9px; background: linear-gradient(135deg, var(--accent), var(--blue)); display: flex; align-items: center; justify-content: center; font-family: 'Syne', sans-serif; font-weight: 700; font-size: 12px; color: white; flex-shrink: 0; }
        .batch-info { flex: 1; min-width: 0; }
        .batch-nm { font-weight: 600; font-size: 13px; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .batch-sub { font-size: 11px; color: var(--muted); }
        .batch-item.active .batch-nm { color: var(--accent); }

        /* MAIN CONTENT */
        .content { flex: 1; padding: 30px; overflow-y: auto; background: var(--bg); }

        /* EMPTY STATE */
        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 400px; color: var(--muted); text-align: center; }
        .empty-icon { font-size: 52px; margin-bottom: 16px; opacity: 0.2; }
        .empty-state h3 { font-family: 'Syne', sans-serif; font-size: 18px; margin-bottom: 8px; color: var(--text); }

        /* BATCH HEADER */
        .batch-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 22px; flex-wrap: wrap; gap: 14px; }
        .batch-title-block { display: flex; align-items: center; gap: 14px; }
        .batch-big-avatar { width: 50px; height: 50px; border-radius: 13px; background: linear-gradient(135deg, var(--accent), var(--blue)); display: flex; align-items: center; justify-content: center; font-family: 'Syne', sans-serif; font-weight: 700; font-size: 16px; color: white; }
        .batch-big-name { font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 800; letter-spacing: -0.4px; }
        .batch-big-sub { font-size: 13px; color: var(--muted); margin-top: 2px; }
        .header-badges { display: flex; gap: 7px; }
        .badge { padding: 4px 13px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-branch { background: #f5f3ff; color: var(--accent); border: 1px solid #ddd6fe; }
        .badge-sem    { background: #f0fdf4; color: var(--green);  border: 1px solid #bbf7d0; }
        .badge-div    { background: #fffbeb; color: var(--yellow); border: 1px solid #fde68a; }

        /* ACTIONS */
        .actions-row { display: flex; gap: 10px; margin-bottom: 20px; }
        .btn-pdf { display: inline-flex; align-items: center; gap: 7px; background: var(--accent); color: white; border: none; padding: 9px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: all 0.2s; text-decoration: none; }
        .btn-pdf:hover { background: var(--accent2); transform: translateY(-1px); }

        /* SECTION TITLE */
        .section-title { font-family: 'Syne', sans-serif; font-size: 14px; font-weight: 700; color: var(--text); margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }
        .section-title::after { content: ''; flex: 1; height: 1px; background: var(--border); }

        /* TIMETABLE */
        .table-wrapper { overflow-x: auto; background: var(--surface); border: 1px solid var(--border); border-radius: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); margin-bottom: 30px; }
        table { width: 100%; border-collapse: collapse; min-width: 700px; }
        thead th { background: var(--light); color: var(--muted); padding: 13px 10px; text-align: center; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; border-bottom: 1px solid var(--border); }
        thead th.day-col { text-align: left; padding-left: 20px; color: var(--text); width: 90px; }
        thead th.lunch-th { color: var(--yellow); }
        thead th.break-th { color: #0284c7; }
        .time-row th { background: #f1f5f9; font-size: 10px; padding: 5px 8px; font-weight: 400; color: #94a3b8; border-bottom: 1px solid var(--border); }
        tbody td { padding: 10px 8px; text-align: center; border: 1px solid var(--border); vertical-align: middle; height: 72px; font-size: 13px; }
        td.day-label { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 12px; color: var(--text); text-align: left; padding-left: 20px; background: var(--light); }
        td.lunch-cell { background: #fefce8; color: var(--yellow); font-size: 11px; font-weight: 600; }
        td.break-cell { background: #f0f9ff; color: #0284c7; font-size: 11px; font-weight: 600; }
        td.subject-cell { background: #f5f3ff; }
        td.lab-cell     { background: #f0fdf4; }
        td.empty-cell   { background: #fafafa; color: #cbd5e1; }
        .subject-name { font-weight: 600; font-size: 12px; display: block; color: var(--text); }
        .faculty-name-cell { font-size: 10px; color: var(--muted); margin-top: 3px; display: block; }
        .lab-badge { display: inline-block; background: #dcfce7; color: var(--green); font-size: 9px; font-weight: 700; padding: 2px 6px; border-radius: 3px; margin-top: 2px; }

        /* FACULTY-SUBJECT TABLE */
        .fs-card { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
        .fs-table { width: 100%; border-collapse: collapse; }
        .fs-table thead tr { background: var(--light); border-bottom: 1px solid var(--border); }
        .fs-table thead th { padding: 13px 20px; text-align: left; font-size: 12px; font-weight: 600; color: var(--muted); }
        .fs-table tbody tr { border-bottom: 1px solid var(--border); transition: background 0.15s; }
        .fs-table tbody tr:last-child { border-bottom: none; }
        .fs-table tbody tr:hover { background: var(--light); }
        .fs-table tbody td { padding: 14px 20px; font-size: 14px; vertical-align: middle; }
        .subject-code-badge { display: inline-block; background: #eff6ff; color: var(--blue); border: 1px solid #bfdbfe; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; margin-left: 8px; }
        .lab-fs-badge { display: inline-block; background: #dcfce7; color: var(--green); font-size: 10px; font-weight: 700; padding: 2px 7px; border-radius: 4px; margin-left: 6px; }
        .faculty-col { display: flex; align-items: center; gap: 10px; }
        .fac-avatar-sm { width: 30px; height: 30px; border-radius: 8px; background: linear-gradient(135deg, var(--blue), var(--accent)); display: flex; align-items: center; justify-content: center; font-family: 'Syne', sans-serif; font-weight: 700; font-size: 11px; color: white; flex-shrink: 0; }
        .fac-name { font-weight: 500; font-size: 14px; color: var(--text); }
        .fac-dept { font-size: 11px; color: var(--muted); }

        /* ERROR */
        .error-box { background: #fef2f2; border: 1px solid #fecaca; color: #dc2626; padding: 13px 18px; border-radius: 10px; margin-bottom: 20px; font-size: 14px; }

        /* PRINT STYLES */
        @media print {
            .topbar, .sidebar, .actions-row, .btn-pdf { display: none !important; }
            .layout { display: block; }
            .content { padding: 0; }
            .table-wrapper, .fs-card { box-shadow: none; border: 1px solid #ccc; }
            body { background: white; }
        }

        @media (max-width: 768px) {
            .layout { flex-direction: column; }
            .sidebar { width: 100%; border-right: none; border-bottom: 1px solid var(--border); }
            .batch-list { max-height: 220px; }
            .content { padding: 20px; }
            .topbar { padding: 0 20px; }
        }
    </style>
</head>
<body>

<%
    List<Batch> allBatches                        = (List<Batch>) request.getAttribute("allBatches");
    Batch selectedBatch                           = (Batch) request.getAttribute("selectedBatch");
    List<Map<String, String>> timetable           = (List<Map<String, String>>) request.getAttribute("timetable");
    List<Map<String, String>> facultySubjects     = (List<Map<String, String>>) request.getAttribute("facultySubjects");
    List<String> workingDays                      = (List<String>) request.getAttribute("workingDays");
    List<Map<String, String>> columns             = (List<Map<String, String>>) request.getAttribute("columns");
    String error                                  = (String) request.getAttribute("error");
    int selectedId = (selectedBatch != null) ? selectedBatch.getId() : -1;

    // Group batches by branch for sidebar
    Map<String, List<Batch>> grouped = new LinkedHashMap<>();
    if (allBatches != null) {
        for (Batch b : allBatches) {
            String key = b.getBranch().toUpperCase() + " · Sem " + b.getSemester();
            grouped.computeIfAbsent(key, k -> new ArrayList<>()).add(b);
        }
    }
%>

<div class="topbar">
    <div class="topbar-logo">En<span>Coder</span></div>
    <div class="topbar-right">
        <span class="role-badge">Student Timetable</span>
    </div>
</div>

<div class="layout">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Select Your Class</h2>
            <input type="text" class="search-input" id="batchSearch"
                   placeholder="Search e.g. CSE sem 3..." onkeyup="filterBatches()">
        </div>
        <div class="batch-list" id="batchList">
            <% for (Map.Entry<String, List<Batch>> entry : grouped.entrySet()) { %>
            <div class="batch-group" data-group="<%= entry.getKey().toLowerCase() %>">
                <div class="batch-group-label"><%= entry.getKey() %></div>
                <% for (Batch b : entry.getValue()) {
                    String initials = b.getBranch().toUpperCase().substring(0, Math.min(2, b.getBranch().length())) + b.getDivision();
                    boolean isActive = (b.getId() == selectedId);
                %>
                <a href="studentTimetable?batchId=<%= b.getId() %>"
                   class="batch-item <%= isActive ? "active" : "" %>"
                   data-name="<%= (b.getBranch() + " sem " + b.getSemester() + " div " + b.getDivision()).toLowerCase() %>">
                    <div class="batch-avatar"><%= initials %></div>
                    <div class="batch-info">
                        <div class="batch-nm"><%= b.getBranch().toUpperCase() %> — Div <%= b.getDivision() %></div>
                        <div class="batch-sub">Semester <%= b.getSemester() %></div>
                    </div>
                </a>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="content" id="printArea">

        <% if (error != null) { %>
        <div class="error-box">&#9888; <%= error %></div>
        <% } %>

        <% if (selectedBatch == null) { %>
        <!-- EMPTY STATE -->
        <div class="empty-state">
            <div class="empty-icon">&#128197;</div>
            <h3>Select Your Class</h3>
            <p style="font-size:14px; margin-top:6px;">Choose your branch, semester and division from the list</p>
        </div>

        <% } else {
            String branchUpper = selectedBatch.getBranch().toUpperCase();
            String initials2   = branchUpper.substring(0, Math.min(2, branchUpper.length())) + selectedBatch.getDivision();

            // Build timetable grid
            Map<String, Map<Integer, Map<String, String>>> grid = new LinkedHashMap<>();
            if (workingDays != null) for (String d : workingDays) grid.put(d, new java.util.HashMap<>());
            if (timetable != null) {
                for (Map<String, String> row : timetable) {
                    String d = row.get("day"); int p = Integer.parseInt(row.get("period"));
                    if (grid.containsKey(d)) grid.get(d).put(p, row);
                }
            }
        %>

        <!-- BATCH HEADER -->
        <div class="batch-header">
            <div class="batch-title-block">
                <div class="batch-big-avatar"><%= initials2 %></div>
                <div>
                    <div class="batch-big-name"><%= branchUpper %> &mdash; Division <%= selectedBatch.getDivision() %></div>
                    <div class="batch-big-sub">Semester <%= selectedBatch.getSemester() %></div>
                </div>
            </div>
            <div class="header-badges">
                <span class="badge badge-branch"><%= branchUpper %></span>
                <span class="badge badge-sem">Sem <%= selectedBatch.getSemester() %></span>
                <span class="badge badge-div">Div <%= selectedBatch.getDivision() %></span>
            </div>
        </div>

        <!-- ACTIONS -->
        <div class="actions-row">
            <button class="btn-pdf" onclick="window.print()">&#128438; Download / Print PDF</button>
        </div>

        <!-- TIMETABLE GRID -->
        <div class="section-title">Weekly Timetable</div>
        <div class="table-wrapper">
            <% if (timetable == null || timetable.isEmpty()) { %>
            <div style="text-align:center; padding:48px; color: var(--muted);">No timetable generated for this batch yet.</div>
            <% } else if (columns == null || columns.isEmpty()) { %>
            <div style="text-align:center; padding:48px; color: var(--muted);">Period timings not configured.</div>
            <% } else { %>
            <table>
                <thead>
                <tr>
                    <th class="day-col">Day</th>
                    <% for (Map<String, String> col : columns) { String ct = col.get("type"); %>
                    <th class="<%= ct.equals("lunch") ? "lunch-th" : ct.equals("break") ? "break-th" : "" %>">
                        <%= ct.equals("lunch") ? "&#127860; Lunch" : ct.equals("break") ? "&#9749; Break" : col.get("label") %>
                    </th>
                    <% } %>
                </tr>
                <tr class="time-row">
                    <th class="day-col"></th>
                    <% for (Map<String, String> col : columns) { %><th><%= col.get("time") %></th><% } %>
                </tr>
                </thead>
                <tbody>
                <% if (workingDays != null) { for (String day : workingDays) { %>
                <tr>
                    <td class="day-label"><%= day.substring(0,3).toUpperCase() %></td>
                    <% for (Map<String, String> col : columns) {
                        String ct = col.get("type");
                        if (ct.equals("lunch")) { %>
                    <td class="lunch-cell">Lunch<br><small><%= col.get("time") %></small></td>
                    <% } else if (ct.equals("break")) { %>
                    <td class="break-cell">Break<br><small><%= col.get("time") %></small></td>
                    <% } else {
                        int pNum = Integer.parseInt(col.get("periodNumber"));
                        Map<Integer, Map<String, String>> dg = grid.get(day);
                        Map<String, String> slot = (dg != null) ? dg.get(pNum) : null;
                        if (slot != null) { boolean isLab = "true".equals(slot.get("isLab")); %>
                    <td class="<%= isLab ? "lab-cell" : "subject-cell" %>">
                        <span class="subject-name"><%= slot.get("subject") %></span>
                        <span class="faculty-name-cell"><%= slot.get("faculty") %></span>
                        <% if (isLab) { %><span class="lab-badge">LAB</span><% } %>
                    </td>
                    <% } else { %><td class="empty-cell">&mdash;</td>
                    <% } } %>
                    <% } %>
                </tr>
                <% } } %>
                </tbody>
            </table>
            <% } %>
        </div>

        <!-- FACULTY-SUBJECT LIST -->
        <% if (facultySubjects != null && !facultySubjects.isEmpty()) { %>
        <div class="section-title">Faculty &amp; Subjects</div>
        <div class="fs-card">
            <table class="fs-table">
                <thead>
                <tr>
                    <th>Subject</th>
                    <th>Faculty</th>
                    <th>Department</th>
                </tr>
                </thead>
                <tbody>
                <% for (Map<String, String> fs : facultySubjects) {
                    boolean isLab = "true".equals(fs.get("isLab"));
                    String code   = fs.get("subjectCode");
                    String facInit = fs.get("facultyName").trim().isEmpty() ? "?" :
                            String.valueOf(fs.get("facultyName").trim().charAt(0)).toUpperCase();
                %>
                <tr>
                    <td>
                        <strong style="font-size:14px;"><%= fs.get("subjectName") %></strong>
                        <% if (code != null && !code.isEmpty()) { %>
                        <span class="subject-code-badge"><%= code %></span>
                        <% } %>
                        <% if (isLab) { %><span class="lab-fs-badge">LAB</span><% } %>
                    </td>
                    <td>
                        <div class="faculty-col">
                            <div class="fac-avatar-sm"><%= facInit %></div>
                            <div>
                                <div class="fac-name"><%= fs.get("facultyName") %></div>
                            </div>
                        </div>
                    </td>
                    <td style="color: var(--muted); font-size:13px;"><%= fs.get("department") %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% } /* end selectedBatch != null */ %>
    </div>
</div>

<script>
    function filterBatches() {
        const q = document.getElementById('batchSearch').value.toLowerCase().trim();
        document.querySelectorAll('.batch-item').forEach(el => {
            const name = el.getAttribute('data-name') || '';
            el.style.display = name.includes(q) ? 'flex' : 'none';
        });
        // Show/hide group labels based on visible items
        document.querySelectorAll('.batch-group').forEach(group => {
            const visible = [...group.querySelectorAll('.batch-item')].some(el => el.style.display !== 'none');
            group.style.display = visible ? 'block' : 'none';
        });
    }
</script>

</body>
</html>
