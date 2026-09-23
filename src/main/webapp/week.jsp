<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.college.model.Faculty" %>
<!DOCTYPE html>
<html>
<head>
  <title>Weekly Timetable</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: Arial, sans-serif; background: #f4f6f9; min-height: 100vh; }

    .topbar { background: #1e40af; color: white; padding: 16px 40px;
      display: flex; justify-content: space-between; align-items: center; }
    .topbar h2 { font-size: 20px; }
    .topbar a { color: white; text-decoration: none; font-size: 13px;
      background: rgba(255,255,255,0.15); padding: 6px 14px;
      border-radius: 6px; }
    .topbar a:hover { background: rgba(255,255,255,0.25); }

    .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }

    .info-bar { display: flex; justify-content: space-between; align-items: center;
      margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
    .info-bar h3 { font-size: 20px; color: #111; }
    .back-btn { background: white; color: #2563eb; border: 1px solid #bfdbfe;
      padding: 8px 18px; border-radius: 8px; font-size: 13px;
      font-weight: 600; text-decoration: none; }
    .back-btn:hover { background: #2563eb; color: white; }

    .table-wrapper { overflow-x: auto; background: white; border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
    table { width: 100%; border-collapse: collapse; min-width: 700px; }

    th { background: #2563eb; color: white; padding: 12px 10px;
      text-align: center; font-size: 13px; font-weight: 600; }
    th.day-col  { background: #1e40af; width: 100px; }
    th.lunch-th { background: #b45309; font-size: 12px; width: 85px; }
    th.break-th { background: #0369a1; font-size: 12px; width: 85px; }
    .time-row th { background: #374151; font-size: 11px; padding: 5px 8px; font-weight: 400; }

    td { padding: 10px 8px; text-align: center; border: 1px solid #e5e7eb;
      vertical-align: middle; height: 70px; font-size: 13px; }
    td.day-label  { font-weight: 700; background: #f0f4ff; color: #1e40af; }
    td.lunch-cell { background: #fef3c7; color: #92400e; font-size: 12px; font-weight: 600; }
    td.break-cell { background: #e0f2fe; color: #075985; font-size: 12px; font-weight: 600; }
    td.subject-cell { background: #eff6ff; color: #1e3a8a; }
    td.lab-cell   { background: #dcfce7; color: #166534; }
    td.free-cell  { background: #fafafa; color: #bbb; font-size: 11px; font-style: italic; }

    .subject-name { font-weight: 600; font-size: 13px; display: block; }
    .batch-info   { font-size: 11px; color: #555; margin-top: 3px; display: block; }
    .lab-badge    { display: inline-block; background: #16a34a; color: white;
      font-size: 9px; padding: 1px 5px; border-radius: 3px; margin-top: 2px; }
    .no-data { text-align: center; padding: 60px; color: #888; font-size: 15px; }
  </style>
</head>
<body>

<%
  com.college.model.Faculty selectedFaculty =
          (com.college.model.Faculty) request.getAttribute("selectedFaculty");
  List<String> workingDays  = (List<String>) request.getAttribute("workingDays");
  List<Map<String, String>> columns = (List<Map<String, String>>) request.getAttribute("columns");
  Map<String, Map<Integer, Map<String, String>>> grid =
          (Map<String, Map<Integer, Map<String, String>>>) request.getAttribute("grid");
  Integer facultyId = (Integer) request.getAttribute("facultyId");
%>

<div class="topbar">
  <h2>Faculty Weekly Timetable</h2>
  <div style="display:flex; gap:12px;">
    <a href="facultyDashboard?facultyId=<%= facultyId %>">← Today's Schedule</a>
    <a href="login.jsp">Logout</a>
  </div>
</div>

<div class="container">
  <div class="info-bar">
    <h3>
      Weekly Timetable
      <% if (selectedFaculty != null) { %>
      — <%= selectedFaculty.getName() %>
      <% if (selectedFaculty.getDepartment() != null) { %>
      <span style="font-size:14px; color:#666; font-weight:400;">
                (<%= selectedFaculty.getDepartment() %>)
            </span>
      <% } } %>
    </h3>
  </div>

  <div class="table-wrapper">
    <% if (columns == null || columns.isEmpty() || workingDays == null) { %>
    <div class="no-data">No timetable data found.</div>
    <% } else { %>
    <table>
      <thead>
      <tr>
        <th class="day-col">Day</th>
        <% for (Map<String, String> col : columns) {
          String ct = col.get("type"); %>
        <th class="<%= ct.equals("lunch") ? "lunch-th" : ct.equals("break") ? "break-th" : "" %>">
          <%= ct.equals("lunch") ? "🍽 " : ct.equals("break") ? "☕ " : "" %><%= col.get("label") %>
        </th>
        <% } %>
      </tr>
      <tr class="time-row">
        <th class="day-col"></th>
        <% for (Map<String, String> col : columns) { %>
        <th><%= col.get("time") %></th>
        <% } %>
      </tr>
      </thead>
      <tbody>
      <% for (String day : workingDays) { %>
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
          Map<Integer, Map<String, String>> dayGrid = grid != null ? grid.get(day) : null;
          Map<String, String> slot = (dayGrid != null) ? dayGrid.get(pNum) : null;
          if (slot != null) {
            boolean isLab = "true".equals(slot.get("isLab")); %>
        <td class="<%= isLab ? "lab-cell" : "subject-cell" %>">
          <span class="subject-name"><%= slot.get("subject") %></span>
          <span class="batch-info">
                                    <%= slot.get("branch") %> | Sem <%= slot.get("semester") %> | Div <%= slot.get("division") %>
                                </span>
          <% if (isLab) { %><span class="lab-badge">LAB</span><% } %>
        </td>
        <% } else { %>
        <td class="free-cell">Free</td>
        <% } } %>
        <% } %>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>

</body>
</html>
