<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.college.model.Batch" %>
<%@ page import="com.college.model.SystemConfig" %>
<!DOCTYPE html>
<html>
<head>
    <title>Timetable View</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; padding: 30px 20px; }
        .page-header { text-align: center; margin-bottom: 24px; }
        .page-header h2 { font-size: 24px; color: #111; }
        .page-header p  { color: #666; margin-top: 6px; font-size: 14px; }
        .actions { display: flex; gap: 12px; justify-content: center; margin-bottom: 24px; }
        .btn { padding: 9px 20px; border-radius: 6px; font-size: 14px; font-weight: 600;
            text-decoration: none; cursor: pointer; border: none; display: inline-block; }
        .btn-primary   { background: #2563eb; color: white; }
        .btn-primary:hover  { background: #1e4fd8; }
        .btn-secondary { background: #e5e7eb; color: #333; }
        .btn-secondary:hover { background: #d1d5db; }
        .tabs { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 20px; justify-content: center; }
        .tab-btn { padding: 8px 18px; border-radius: 6px; font-size: 13px; font-weight: 600;
            cursor: pointer; border: 2px solid #2563eb; background: white; color: #2563eb; }
        .tab-btn.active, .tab-btn:hover { background: #2563eb; color: white; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .table-wrapper { overflow-x: auto; background: white; border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08); margin-bottom: 30px; }
        table { width: 100%; border-collapse: collapse; min-width: 700px; }

        /* Period header */
        th { background: #2563eb; color: white; padding: 12px 10px; text-align: center; font-size: 13px; font-weight: 600; }
        th.day-col   { background: #1e40af; width: 90px; }
        th.lunch-th  { background: #b45309; color: white; font-size: 12px; width: 85px; }
        th.break-th  { background: #0369a1; color: white; font-size: 12px; width: 85px; }

        /* Time row */
        .time-row th { background: #374151; font-size: 11px; padding: 5px 8px; font-weight: 400; }

        /* Cells */
        td { padding: 10px 8px; text-align: center; border: 1px solid #e5e7eb;
            vertical-align: middle; height: 68px; font-size: 13px; }
        td.day-label    { font-weight: 700; background: #f0f4ff; color: #1e40af; width: 90px; }
        td.lunch-cell   { background: #fef3c7; color: #92400e; font-size: 12px; font-weight: 600; width: 85px; }
        td.break-cell   { background: #e0f2fe; color: #075985; font-size: 12px; font-weight: 600; width: 85px; }
        td.subject-cell { background: #eff6ff; color: #1e3a8a; }
        td.lab-cell     { background: #dcfce7; color: #166534; }
        td.empty-cell   { background: #fafafa; color: #bbb; font-size: 11px; font-style: italic; }

        .subject-name { font-weight: 600; font-size: 13px; display: block; }
        .faculty-name { font-size: 11px; color: #555; margin-top: 3px; display: block; }
        .lab-badge    { display: inline-block; background: #16a34a; color: white;
            font-size: 9px; padding: 1px 5px; border-radius: 3px; margin-top: 3px; }

        .no-data { text-align: center; padding: 40px; color: #888; font-size: 15px; }
        .msg-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0;
            padding: 12px 20px; border-radius: 8px; margin-bottom: 20px;
            text-align: center; font-size: 14px; font-weight: 600; }
        .msg-warning { background: #fef9c3; color: #854d0e; border: 1px solid #fde047;
            padding: 12px 20px; border-radius: 8px; margin-bottom: 20px;
            font-size: 13px; white-space: pre-line; }
        .msg-warning strong { display: block; margin-bottom: 6px; font-size: 14px; }
    </style>
</head>
<body>

<%
    List<Batch> allBatches = (List<Batch>) request.getAttribute("allBatches");
    Map<Integer, List<Map<String, String>>> allTimetables =
            (Map<Integer, List<Map<String, String>>>) request.getAttribute("allTimetables");
    List<String> workingDays = (List<String>) request.getAttribute("workingDays");
    List<Map<String, String>> columns = (List<Map<String, String>>) request.getAttribute("columns");
%>

<div class="page-header">
    <h2>Generated Timetables</h2>
    <p>All batches — faculty clashes prevented across all divisions</p>
</div>

<div class="actions">
    <a href="adminDashboard" class="btn btn-secondary">← Admin Dashboard</a>
    <form action="generateTimetable" method="post" style="display:inline;">
        <button type="submit" class="btn btn-primary"
                onclick="return confirm('Regenerate all timetables?')">↻ Regenerate All</button>
    </form>
</div>

<%-- Flash message --%>
<%
    String genMsg = (String) session.getAttribute("genMessage");
    session.removeAttribute("genMessage");
    if (genMsg != null) {
        boolean hasWarn = genMsg.contains("Warning") || genMsg.contains("Only placed") || genMsg.contains("No faculty");
        if (hasWarn) { %>
<div class="msg-warning">
    <strong>⚠ Timetable generated with some gaps:</strong>
    <%= genMsg.replace("SUCCESS\nWarnings:\n","").replace("SUCCESS","").trim() %>
    <br><small>Slots that could not be filled are shown as Free below.</small>
</div>
<%  } else { %>
<div class="msg-success">✅ All timetables generated successfully — no gaps!</div>
<%  } } %>

<% if (allBatches == null || allBatches.isEmpty()) { %>
<div class="no-data">No batches found. Please create batches from the Admin Dashboard.</div>
<% } else { %>

<%-- Tabs --%>
<div class="tabs">
    <% for (int i = 0; i < allBatches.size(); i++) {
        Batch tb = allBatches.get(i); %>
    <button class="tab-btn <%= i == 0 ? "active" : "" %>"
            onclick="showTab(<%= tb.getId() %>, this)">
        <%= tb.getBranch().toUpperCase() %> Sem<%= tb.getSemester() %> Div <%= tb.getDivision() %>
    </button>
    <% } %>
</div>

<%-- One table per batch --%>
<% for (int i = 0; i < allBatches.size(); i++) {
    Batch batch = allBatches.get(i);
    List<Map<String, String>> timetable = allTimetables.get(batch.getId());

    // Build lookup: day -> periodNumber -> slot data
    Map<String, Map<Integer, Map<String, String>>> grid = new LinkedHashMap<>();
    if (workingDays != null) for (String d : workingDays) grid.put(d, new HashMap<>());
    if (timetable != null) {
        for (Map<String, String> row : timetable) {
            String d = row.get("day");
            int    p = Integer.parseInt(row.get("period"));
            if (grid.containsKey(d)) grid.get(d).put(p, row);
        }
    }
%>
<div id="tab-<%= batch.getId() %>" class="tab-content <%= i == 0 ? "active" : "" %>">
    <div class="table-wrapper">
        <% if (timetable == null || timetable.isEmpty()) { %>
        <div class="no-data">No timetable generated for this batch yet.</div>
        <% } else if (columns == null || columns.isEmpty()) { %>
        <div class="no-data">Period timings not configured.</div>
        <% } else { %>
        <table>
            <thead>
            <%-- Header row: Day | Period 1 | Lunch Break | Period 2 | ... --%>
            <tr>
                <th class="day-col">Day</th>
                <% for (Map<String, String> col : columns) {
                    String ct = col.get("type"); %>
                <th class="<%= ct.equals("lunch") ? "lunch-th" : ct.equals("break") ? "break-th" : "" %>">
                    <%= ct.equals("lunch") ? "🍽 " : ct.equals("break") ? "☕ " : "" %><%= col.get("label") %>
                </th>
                <% } %>
            </tr>
            <%-- Time row --%>
            <tr class="time-row">
                <th class="day-col"></th>
                <% for (Map<String, String> col : columns) { %>
                <th><%= col.get("time") %></th>
                <% } %>
            </tr>
            </thead>
            <tbody>
            <% if (workingDays != null) { for (String day : workingDays) { %>
            <tr>
                <td class="day-label"><%= day %></td>
                <% for (Map<String, String> col : columns) {
                    String ct = col.get("type");
                    if (ct.equals("lunch")) { %>
                <td class="lunch-cell">Lunch<br><small><%= col.get("time") %></small></td>
                <% } else if (ct.equals("break")) { %>
                <td class="break-cell">Break<br><small><%= col.get("time") %></small></td>
                <% } else {
                    int pNum = Integer.parseInt(col.get("periodNumber"));
                    Map<Integer, Map<String, String>> dayGrid = grid.get(day);
                    Map<String, String> slot = (dayGrid != null) ? dayGrid.get(pNum) : null;
                    if (slot != null) {
                        boolean isLab = "true".equals(slot.get("isLab")); %>
                <td class="<%= isLab ? "lab-cell" : "subject-cell" %>">
                    <span class="subject-name"><%= slot.get("subject") %></span>
                    <span class="faculty-name"><%= slot.get("faculty") %></span>
                    <% if (isLab) { %><span class="lab-badge">LAB</span><% } %>
                </td>
                <% } else { %>
                <td class="empty-cell">Free</td>
                <% } }%>
                <% } %>
            </tr>
            <% } } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
<% } %>
<% } %>

<script>
    function showTab(batchId, btn) {
        document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + batchId).classList.add('active');
        btn.classList.add('active');
    }
</script>
</body>
</html>
