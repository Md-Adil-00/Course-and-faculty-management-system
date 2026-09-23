<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.college.model.Faculty" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #f4f6fb; --surface: #ffffff; --card: #ffffff; --border: #e2e8f0;
            --accent: #2563eb; --green: #16a34a; --yellow: #d97706; --purple: #7c3aed;
            --text: #0f172a; --muted: #64748b; --light: #f8fafc;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        /* TOPBAR */
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 0 40px; display: flex; align-items: center; justify-content: space-between; height: 58px; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
        .topbar-logo { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 18px; color: var(--text); }
        .topbar-logo span { color: var(--accent); }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .role-badge { background: #eff6ff; color: var(--accent); border: 1px solid #bfdbfe; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .btn-link { color: var(--muted); font-size: 13px; text-decoration: none; padding: 6px 14px; border: 1px solid var(--border); border-radius: 6px; transition: all 0.2s; }
        .btn-link:hover { color: var(--text); border-color: #94a3b8; }

        /* LAYOUT */
        .layout { display: flex; min-height: calc(100vh - 58px); }

        /* SIDEBAR */
        .sidebar { width: 270px; background: var(--surface); border-right: 1px solid var(--border); flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar-header { padding: 20px 16px 14px; border-bottom: 1px solid var(--border); }
        .sidebar-header h2 { font-family: 'Syne', sans-serif; font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 12px; }
        .search-input { width: 100%; background: var(--light); border: 1px solid var(--border); color: var(--text); padding: 9px 13px; border-radius: 8px; font-size: 13px; font-family: 'DM Sans', sans-serif; outline: none; }
        .search-input::placeholder { color: #94a3b8; }
        .search-input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(37,99,235,0.08); }
        .faculty-list { flex: 1; overflow-y: auto; padding: 8px; }
        .faculty-item { display: flex; align-items: center; gap: 11px; padding: 10px 12px; border-radius: 9px; cursor: pointer; transition: all 0.15s; text-decoration: none; margin-bottom: 2px; border: 1px solid transparent; }
        .faculty-item:hover { background: var(--light); }
        .faculty-item.active { background: #eff6ff; border-color: #bfdbfe; }
        .faculty-avatar { width: 34px; height: 34px; border-radius: 9px; background: linear-gradient(135deg, var(--accent), var(--purple)); display: flex; align-items: center; justify-content: center; font-family: 'Syne', sans-serif; font-weight: 700; font-size: 13px; color: white; flex-shrink: 0; }
        .faculty-info { flex: 1; min-width: 0; }
        .faculty-nm { font-weight: 500; font-size: 13px; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .faculty-dp { font-size: 11px; color: var(--muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .faculty-item.active .faculty-nm { color: var(--accent); }

        /* MAIN CONTENT */
        .content { flex: 1; padding: 32px; overflow-y: auto; background: var(--bg); }

        /* EMPTY STATE */
        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 400px; color: var(--muted); text-align: center; }
        .empty-icon { font-size: 48px; margin-bottom: 16px; opacity: 0.25; }
        .empty-state h3 { font-family: 'Syne', sans-serif; font-size: 18px; margin-bottom: 8px; color: var(--text); }

        /* FACULTY HEADER */
        .faculty-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; flex-wrap: wrap; gap: 14px; }
        .faculty-title-block { display: flex; align-items: center; gap: 14px; }
        .faculty-big-avatar { width: 48px; height: 48px; border-radius: 13px; background: linear-gradient(135deg, var(--accent), var(--purple)); display: flex; align-items: center; justify-content: center; font-family: 'Syne', sans-serif; font-weight: 700; font-size: 19px; color: white; }
        .faculty-big-name { font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 800; letter-spacing: -0.4px; }
        .faculty-big-dept { font-size: 13px; color: var(--muted); margin-top: 2px; }

        /* VIEW TOGGLE */
        .view-toggle { display: flex; gap: 8px; }
        .toggle-btn { padding: 8px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; border: 1px solid var(--border); background: var(--surface); color: var(--muted); font-family: 'DM Sans', sans-serif; text-decoration: none; transition: all 0.2s; display: inline-block; }
        .toggle-btn:hover { border-color: var(--accent); color: var(--accent); }
        .toggle-btn.active { background: var(--accent); border-color: var(--accent); color: white; }

        /* SECTION HEADER */
        .section-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
        .section-title { font-family: 'Syne', sans-serif; font-size: 16px; font-weight: 700; color: var(--text); display: flex; align-items: center; gap: 10px; }
        .today-dot { width: 8px; height: 8px; background: var(--green); border-radius: 50%; display: inline-block; animation: pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:0.3;} }
        .today-tag { font-size: 12px; color: var(--muted); font-family: 'DM Sans', sans-serif; font-weight: 400; }

        /* TODAY TABLE — matches the design in the image */
        .today-card { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.05); }
        .today-table { width: 100%; border-collapse: collapse; }
        .today-table thead tr { border-bottom: 1px solid var(--border); background: var(--light); }
        .today-table thead th { padding: 14px 20px; text-align: left; font-size: 13px; font-weight: 600; color: var(--muted); font-family: 'DM Sans', sans-serif; }
        .today-table tbody tr { border-bottom: 1px solid var(--border); transition: background 0.15s; }
        .today-table tbody tr:last-child { border-bottom: none; }
        .today-table tbody tr:hover { background: var(--light); }
        .today-table tbody td { padding: 16px 20px; font-size: 14px; color: var(--text); vertical-align: middle; }
        .today-table tbody td.class-num { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 18px; color: var(--text); }
        .today-table tbody td.branch-cell { color: var(--muted); font-size: 13px; }
        .today-table tbody td.time-cell { font-weight: 500; color: var(--text); }
        .today-table tbody td.hour-cell { color: var(--muted); font-size: 13px; }
        .lab-tag { display: inline-block; background: #dcfce7; color: var(--green); font-size: 10px; font-weight: 700; padding: 2px 7px; border-radius: 4px; margin-left: 6px; vertical-align: middle; }
        .empty-row td { color: #cbd5e1; font-style: italic; font-size: 13px; text-align: center; padding: 28px; }
        .no-class-msg { text-align: center; padding: 52px 20px; color: var(--muted); }
        .no-class-msg .icon { font-size: 32px; margin-bottom: 10px; opacity: 0.3; }
        .no-class-msg strong { display: block; margin-bottom: 4px; font-size: 15px; color: var(--text); }

        /* WEEK GRID TABLE */
        .table-wrapper { overflow-x: auto; background: var(--surface); border: 1px solid var(--border); border-radius: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; min-width: 700px; }
        thead th { background: var(--light); color: var(--muted); padding: 13px 10px; text-align: center; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; border-bottom: 1px solid var(--border); }
        thead th.day-col { text-align: left; padding-left: 20px; color: var(--text); width: 90px; }
        thead th.lunch-th { color: var(--yellow); }
        thead th.break-th { color: #0284c7; }
        .time-row th { background: #f1f5f9; font-size: 10px; padding: 5px 8px; font-weight: 400; color: #94a3b8; border-bottom: 1px solid var(--border); }
        tbody td { padding: 10px 8px; text-align: center; border: 1px solid var(--border); vertical-align: middle; height: 68px; font-size: 13px; }
        td.day-label { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 12px; color: var(--text); text-align: left; padding-left: 20px; background: var(--light); }
        td.lunch-cell { background: #fefce8; color: var(--yellow); font-size: 11px; font-weight: 600; }
        td.break-cell { background: #f0f9ff; color: #0284c7; font-size: 11px; font-weight: 600; }
        td.has-class  { background: #eff6ff; }
        td.lab-class  { background: #f0fdf4; }
        td.empty-cell { background: #fafafa; color: #cbd5e1; font-size: 11px; }
        .cell-subject { font-weight: 600; font-size: 12px; display: block; color: var(--text); }
        .cell-batch   { font-size: 10px; color: var(--muted); margin-top: 3px; display: block; }
        .cell-lab     { display: inline-block; background: #dcfce7; color: var(--green); font-size: 9px; font-weight: 700; padding: 2px 5px; border-radius: 3px; margin-top: 2px; }

        @media (max-width: 768px) {
            .layout { flex-direction: column; }
            .sidebar { width: 100%; border-right: none; border-bottom: 1px solid var(--border); }
            .faculty-list { max-height: 220px; }
            .content { padding: 20px; }
            .topbar { padding: 0 20px; }
        }
    </style>
</head>
<body>

<%
    List<Faculty> allFaculty                = (List<Faculty>) request.getAttribute("allFaculty");
    Faculty selectedFaculty                 = (Faculty) request.getAttribute("selectedFaculty");
    String view                             = (String) request.getAttribute("view");
    List<Map<String, String>> todaySchedule = (List<Map<String, String>>) request.getAttribute("todaySchedule");
    List<Map<String, String>> weekSchedule  = (List<Map<String, String>>) request.getAttribute("weekSchedule");
    List<Map<String, String>> columns       = (List<Map<String, String>>) request.getAttribute("columns");
    List<String> workingDays                = (List<String>) request.getAttribute("workingDays");
    String today                            = (String) request.getAttribute("today");
    int selectedId = (selectedFaculty != null) ? selectedFaculty.getId() : -1;
%>

<div class="topbar">
    <div class="topbar-logo">En<span>Coder</span></div>
    <div class="topbar-right">
        <span class="role-badge">Faculty Portal</span>
        <a href="index.jsp" class="btn-link">&#8592; Home</a>
    </div>
</div>

<div class="layout">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Faculty Members</h2>
            <input type="text" class="search-input" id="facultySearch" placeholder="Search by name..." onkeyup="filterFaculty()">
        </div>
        <div class="faculty-list" id="facultyList">
            <% if (allFaculty != null) { for (Faculty f : allFaculty) {
                String init = f.getName().trim().isEmpty() ? "?" : String.valueOf(f.getName().trim().charAt(0)).toUpperCase();
                boolean isActive = (f.getId() == selectedId);
            %>
            <a href="facultyDashboard?facultyId=<%= f.getId() %>&view=today"
               class="faculty-item <%= isActive ? "active" : "" %>" data-name="<%= f.getName().toLowerCase() %>">
                <div class="faculty-avatar"><%= init %></div>
                <div class="faculty-info">
                    <div class="faculty-nm"><%= f.getName() %></div>
                    <div class="faculty-dp"><%= f.getDepartment() %></div>
                </div>
            </a>
            <% } } %>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="content">

        <% if (selectedFaculty == null) { %>
        <div class="empty-state">
            <div class="empty-icon">&#128072;</div>
            <h3>Select a Faculty Member</h3>
            <p style="font-size:14px; margin-top:6px;">Click any name from the list to view their timetable</p>
        </div>

        <% } else {
            String init2 = selectedFaculty.getName().trim().isEmpty() ? "?" : String.valueOf(selectedFaculty.getName().trim().charAt(0)).toUpperCase();
        %>

        <!-- FACULTY HEADER -->
        <div class="faculty-header">
            <div class="faculty-title-block">
                <div class="faculty-big-avatar"><%= init2 %></div>
                <div>
                    <div class="faculty-big-name"><%= selectedFaculty.getName() %></div>
                    <div class="faculty-big-dept"><%= selectedFaculty.getDepartment() %></div>
                </div>
            </div>
            <div class="view-toggle">
                <a href="facultyDashboard?facultyId=<%= selectedFaculty.getId() %>&view=today"
                   class="toggle-btn <%= !"week".equals(view) ? "active" : "" %>">Today's Schedule</a>
                <a href="facultyDashboard?facultyId=<%= selectedFaculty.getId() %>&view=week"
                   class="toggle-btn <%= "week".equals(view) ? "active" : "" %>">Week's Schedule</a>
            </div>
        </div>

        <!-- ======== TODAY VIEW ======== -->
        <% if (!"week".equals(view)) { %>

        <div class="section-header">
            <div class="section-title">
                <span class="today-dot"></span>
                Today's Schedule
                <span class="today-tag">— <%= today %></span>
            </div>
        </div>

        <div class="today-card">
            <% if (todaySchedule == null || todaySchedule.isEmpty()) { %>
            <div class="no-class-msg">
                <div class="icon">&#127881;</div>
                <strong>No Classes Today</strong>
                <span style="font-size:13px;">Enjoy your free day!</span>
            </div>
            <% } else { %>
            <table class="today-table">
                <thead>
                <tr>
                    <th>Class</th>
                    <th>Branch</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Total Hour</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // Calculate total teaching hours across all slots today
                    int totalMinutesToday = 0;
                    for (Map<String, String> slot : todaySchedule) {
                        String st = slot.get("startTime24");
                        String et = slot.get("endTime24");
                        if (st != null && et != null) {
                            try {
                                String[] sp = st.split(":");
                                String[] ep = et.split(":");
                                int sm = Integer.parseInt(sp[0])*60 + Integer.parseInt(sp[1]);
                                int em = Integer.parseInt(ep[0])*60 + Integer.parseInt(ep[1]);
                                totalMinutesToday += Math.max(0, em - sm);
                            } catch (Exception ex) {}
                        }
                    }

                    // Group consecutive periods of same batch as one class block
                    // Show each period as one row
                    for (Map<String, String> slot : todaySchedule) {
                        boolean isLab = "true".equals(slot.get("isLab"));
                        String branchDiv = slot.get("branch") + " " + slot.get("division");
                        String subjectLabel = slot.get("subject");

                        // Calculate duration
                        String st = slot.get("startTime24");
                        String et = slot.get("endTime24");
                        String duration = "";
                        if (st != null && et != null) {
                            try {
                                String[] sp = st.split(":");
                                String[] ep = et.split(":");
                                int sm = Integer.parseInt(sp[0])*60 + Integer.parseInt(sp[1]);
                                int em = Integer.parseInt(ep[0])*60 + Integer.parseInt(ep[1]);
                                int diff = em - sm;
                                if (diff >= 60) {
                                    int hrs = diff / 60; int mins = diff % 60;
                                    duration = hrs + " hr" + (hrs > 1 ? "s" : "") + (mins > 0 ? " " + mins + " min" : "");
                                } else {
                                    duration = diff + " min";
                                }
                            } catch (Exception ex) { duration = "—"; }
                        }
                %>
                <tr>
                    <td class="class-num">
                        Period <%= slot.get("period") %>
                        <% if (isLab) { %><span class="lab-tag">LAB</span><% } %>
                    </td>
                    <td class="branch-cell">
                        <strong style="color: var(--text); font-size:14px;"><%= branchDiv %></strong><br>
                        <span style="font-size:11px; color: var(--muted);">Sem <%= slot.get("semester") %> &middot; <%= subjectLabel %></span>
                    </td>
                    <td class="time-cell"><%= slot.get("startTime") %></td>
                    <td class="time-cell"><%= slot.get("endTime") %></td>
                    <td class="hour-cell"><%= duration.isEmpty() ? "—" : duration %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>

        <!-- ======== WEEK VIEW ======== -->
        <% } else {
            Map<String, Map<Integer, Map<String, String>>> weekGrid = new LinkedHashMap<>();
            if (workingDays != null) for (String d : workingDays) weekGrid.put(d, new java.util.HashMap<>());
            if (weekSchedule != null) {
                for (Map<String, String> row : weekSchedule) {
                    String d = row.get("day"); int p = Integer.parseInt(row.get("period"));
                    if (weekGrid.containsKey(d)) weekGrid.get(d).put(p, row);
                }
            }
        %>

        <div class="section-header">
            <div class="section-title">Week's Schedule</div>
        </div>

        <div class="table-wrapper">
            <% if (weekSchedule == null || weekSchedule.isEmpty()) { %>
            <div class="no-class-msg" style="border:none;padding:52px;">
                <div class="icon">&#128241;</div>
                <strong>No timetable assigned yet</strong>
            </div>
            <% } else if (columns == null || columns.isEmpty()) { %>
            <div class="no-class-msg">Period timings not configured.</div>
            <% } else { %>
            <table>
                <thead>
                <tr>
                    <th class="day-col">Day</th>
                    <% for (Map<String, String> col : columns) { String ct = col.get("type"); %>
                    <th class="<%= ct.equals("lunch") ? "lunch-th" : ct.equals("break") ? "break-th" : "" %>">
                        <%= ct.equals("lunch") ? "Lunch" : ct.equals("break") ? "Break" : col.get("label") %>
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
                        if (ct.equals("lunch")) { %><td class="lunch-cell">Lunch<br><small><%= col.get("time") %></small></td>
                    <% } else if (ct.equals("break")) { %><td class="break-cell">Break<br><small><%= col.get("time") %></small></td>
                    <% } else {
                        int pNum = Integer.parseInt(col.get("periodNumber"));
                        Map<Integer, Map<String, String>> dg = weekGrid.get(day);
                        Map<String, String> slot = (dg != null) ? dg.get(pNum) : null;
                        if (slot != null) { boolean isLab = "true".equals(slot.get("isLab")); %>
                    <td class="<%= isLab ? "lab-class" : "has-class" %>">
                        <span class="cell-subject"><%= slot.get("subject") %></span>
                        <span class="cell-batch"><%= slot.get("branch") %> Sem<%= slot.get("semester") %> Div<%= slot.get("division") %></span>
                        <% if (isLab) { %><span class="cell-lab">LAB</span><% } %>
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
        <% } %>

        <% } /* end selectedFaculty != null */ %>
    </div>
</div>

<script>
    function filterFaculty() {
        const q = document.getElementById('facultySearch').value.toLowerCase();
        document.querySelectorAll('.faculty-item').forEach(el => {
            el.style.display = el.getAttribute('data-name').includes(q) ? 'flex' : 'none';
        });
    }
</script>
</body>
</html>
