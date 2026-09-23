<%--
  Created by IntelliJ IDEA.
  User: Mohammed Adil
  Date: 12-02-2026
  Time: 06:55 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Faculty Dashboard</title>
    <link rel="stylesheet" href="css/faculty.css">
</head>

<body>

<div class="container">

    <div class="header">
        <h2>Faculty Dashboard</h2>

        <div class="button-group">
            <a href="faculty.jsp" class="btn active">Today</a>
            <a href="week.jsp" class="btn">Week</a>
        </div>
    </div>

    <div class="card">
        <h3>Today's Schedule</h3>

        <table>
            <thead>
            <tr>
                <th>Period</th>
                <th>Branch</th>
                <th>Subject</th>
                <th>Time</th>
            </tr>
            </thead>
            <tbody>
            <!-- Data will come from database later -->
            </tbody>
        </table>

    </div>

</div>

</body>
</html>
