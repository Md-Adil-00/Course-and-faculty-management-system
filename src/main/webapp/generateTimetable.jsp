<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Generate Timetable</title>
    <link href="css/admin.css" rel="stylesheet">
    <style>
        .gen-card {
            width: 480px;
            margin: 80px auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            text-align: center;
        }
        .gen-card h2 { margin-bottom: 12px; }
        .gen-card p  { color: #555; font-size: 14px; margin-bottom: 24px; line-height: 1.6; }
        .gen-card button { width: 100%; padding: 13px; font-size: 15px; font-weight: 600; margin-top: 0; }
        .back-link { display: block; margin-top: 16px; font-size: 14px; color: #2563eb; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
        .error { background: #fee2e2; color: #991b1b; padding: 12px; border-radius: 6px; margin-bottom: 16px; font-size: 14px; }
    </style>
</head>
<body style="background-color:#f4f6f9;">
<div class="gen-card">

    <h2>Generate All Timetables</h2>

    <% String error = (String) request.getAttribute("error");
        if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <p>
        This will generate timetables for <strong>all batches</strong> simultaneously.<br>
        Faculty clashes are automatically prevented across all divisions.
    </p>

    <form action="generateTimetable" method="post">
        <button type="submit">Generate Now</button>
    </form>

    <a href="adminDashboard" class="back-link">← Back to Admin Dashboard</a>
</div>
</body>
</html>
