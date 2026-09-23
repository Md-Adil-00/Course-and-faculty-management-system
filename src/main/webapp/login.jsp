<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { min-height: 100vh; display: flex; justify-content: center; align-items: center;
      background: #f4f6f9; font-family: Arial, sans-serif; }

    .login-wrapper { display: flex; flex-direction: column; align-items: center; gap: 20px; width: 360px; }

    .college-title { font-size: 22px; font-weight: 700; color: #1e40af; text-align: center; }
    .college-sub   { font-size: 13px; color: #666; text-align: center; margin-top: 4px; }

    .card { background: white; border-radius: 14px; padding: 32px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.09); width: 100%; }
    .card h3 { font-size: 17px; color: #111; margin-bottom: 22px; text-align: center; }

    .tabs { display: flex; border-radius: 8px; overflow: hidden;
      border: 1px solid #e5e7eb; margin-bottom: 24px; }
    .tab { flex: 1; padding: 10px; text-align: center; font-size: 13px; font-weight: 600;
      cursor: pointer; color: #666; background: #f9fafb; border: none; }
    .tab.active { background: #2563eb; color: white; }

    .form-group { margin-bottom: 16px; }
    .form-group label { display: block; font-size: 12px; color: #555;
      font-weight: 600; margin-bottom: 6px; }
    .form-group input { width: 100%; padding: 11px 14px; border: 1px solid #d1d5db;
      border-radius: 8px; font-size: 14px; outline: none; }
    .form-group input:focus { border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }

    .login-btn { width: 100%; padding: 12px; background: #2563eb; color: white;
      border: none; border-radius: 8px; font-size: 15px; font-weight: 700;
      cursor: pointer; }
    .login-btn:hover { background: #1e4fd8; }

    .divider { display: flex; align-items: center; gap: 12px; margin: 20px 0; }
    .divider hr { flex: 1; border: none; border-top: 1px solid #e5e7eb; }
    .divider span { font-size: 12px; color: #aaa; }

    .student-btn { width: 100%; padding: 12px; background: white; color: #2563eb;
      border: 2px solid #2563eb; border-radius: 8px; font-size: 14px;
      font-weight: 700; cursor: pointer; text-align: center;
      text-decoration: none; display: block; }
    .student-btn:hover { background: #eff6ff; }

    .error-msg { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca;
      padding: 10px 14px; border-radius: 8px; font-size: 13px;
      margin-bottom: 16px; text-align: center; }
  </style>
</head>
<body>

<div class="login-wrapper">

  <div>
    <div class="college-title">🎓 EnCoder Timetable System</div>
    <div class="college-sub">Manage and view timetables</div>
  </div>

  <div class="card">

    <% String error = request.getParameter("error"); %>
    <% if (error != null) { %>
    <div class="error-msg">Invalid email or password. Please try again.</div>
    <% } %>

    <!-- Tabs -->
    <div class="tabs">
      <button class="tab active" onclick="showTab('admin', this)">Admin</button>
      <button class="tab" onclick="showTab('faculty', this)">Faculty</button>
    </div>

    <!-- Admin Login -->
    <div id="tab-admin">
      <form action="login" method="post">
        <input type="hidden" name="loginType" value="admin">
        <div class="form-group">
          <label>Email</label>
          <input type="text" name="email" placeholder="admin@gmail.com" required>
        </div>
        <div class="form-group">
          <label>Password</label>
          <input type="password" name="password" placeholder="••••••••" required>
        </div>
        <button type="submit" class="login-btn">Login as Admin</button>
      </form>
    </div>

    <!-- Faculty Login -->
    <div id="tab-faculty" style="display:none;">
      <form action="login" method="post">
        <input type="hidden" name="loginType" value="faculty">
        <div class="form-group">
          <label>Email</label>
          <input type="text" name="email" placeholder="faculty@gmail.com" required>
        </div>
        <div class="form-group">
          <label>Password</label>
          <input type="password" name="password" placeholder="••••••••" required>
        </div>
        <button type="submit" class="login-btn" style="background:#059669;">Login as Faculty</button>
      </form>
    </div>

    <div class="divider"><hr><span>or</span><hr></div>

    <a href="studentTimetable" class="student-btn">👨‍🎓 Student — View Timetables</a>

  </div>
</div>

<script>
  function showTab(name, btn) {
    document.getElementById('tab-admin').style.display   = name === 'admin'   ? 'block' : 'none';
    document.getElementById('tab-faculty').style.display = name === 'faculty' ? 'block' : 'none';
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    btn.classList.add('active');
  }
</script>

</body>
</html>
