<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>AnyCode Online Compiler</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Fira Code', monospace;
      background: #0d1117;
      color: #c9d1d9;
      display: flex;
      flex-direction: column;
      height: 100vh;
    }

    header {
      background: #161b22;
      padding: 12px 24px;
      font-size: 18px;
      font-weight: bold;
      color: #58a6ff;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 2px 4px rgba(0,0,0,0.5);
    }

    header img {
      height: 32px;
    }

    .container {
      display: flex;
      flex: 1;
      overflow: hidden;
    }

    .sidebar {
      background: #161b22;
      width: 70px;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 10px 0;
      border-right: 1px solid #30363d;
    }

    .lang-btn {
      background: #21262d;
      border: 1px solid #30363d;
      color: #8b949e;
      width: 44px;
      height: 44px;
      margin: 6px 0;
      border-radius: 4px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 11px;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .lang-btn.active {
      background: #238636;
      border-color: #2ea043;
      color: #fff;
    }

    .lang-btn:hover {
      background: #238636;
      border-color: #2ea043;
      color: #fff;
    }

    .main {
      flex: 1;
      display: flex;
      flex-direction: column;
      padding: 10px;
      gap: 10px;
    }

    .pane {
      background: #161b22;
      border: 1px solid #30363d;
      border-radius: 6px;
      padding: 10px;
      display: flex;
      flex-direction: column;
    }

    .pane textarea {
      background: transparent;
      border: none;
      resize: none;
      color: #f0f6fc;
      font-size: 14px;
      outline: none;
      flex: 1;
      width: 100%;
    }

    .controls {
      display: flex;
      gap: 8px;
      margin-bottom: 6px;
    }

    .controls button {
      background: #21262d;
      color: #c9d1d9;
      border: 1px solid #30363d;
      padding: 6px 14px;
      border-radius: 4px;
      font-size: 13px;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .controls button:hover {
      background: #238636;
      border-color: #2ea043;
      color: #fff;
    }

    .output-title {
      font-size: 13px;
      color: #58a6ff;
      margin-bottom: 4px;
    }

    .output-content {
      white-space: pre-wrap;
      color: #3fb950;
      overflow-y: auto;
      max-height: 200px;
    }
  </style>
  <script>
    function setLanguage(lang) {
      document.getElementById('languageInput').value = lang;

    
      const buttons = document.querySelectorAll('.lang-btn');
      buttons.forEach(btn => btn.classList.remove('active'));

     
      const activeBtn = document.getElementById('btn-' + lang);
      if (activeBtn) {
        activeBtn.classList.add('active');
      }
    }

    function clearAll() {
      document.getElementById('codeArea').value = '';
      document.getElementById('inputArea').value = '';
      document.getElementById('outputBox').innerText = 'Output will appear here...';
    }

    function clearOutput() {
      document.getElementById('outputBox').innerText = 'Output will appear here...';
    }

    window.onload = function() {
      setLanguage(document.getElementById('languageInput').value);
    };
  </script>
</head>
<body>

<header>
  AnyCode Online Compiler
  <img src="images/anycode.png" alt="AnyCode Logo">
</header>

<form method="POST" action="codecompiler">
  <input type="hidden" name="language" id="languageInput" value="<%= request.getParameter("language") != null ? request.getParameter("language") : "java" %>">

  <div class="container">
    <div class="sidebar">
      <div id="btn-java" class="lang-btn" onclick="setLanguage('java')">Java</div>
      <div id="btn-c" class="lang-btn" onclick="setLanguage('c')">C</div>
      <div id="btn-cpp" class="lang-btn" onclick="setLanguage('cpp')">C++</div>
      <div id="btn-python" class="lang-btn" onclick="setLanguage('python')">Py</div>
      <div id="btn-javascript" class="lang-btn" onclick="setLanguage('javascript')">JS</div>
      <div id="btn-go" class="lang-btn" onclick="setLanguage('go')">Go</div>
      <div id="btn-ruby" class="lang-btn" onclick="setLanguage('ruby')">Rb</div>
    </div>

    <div class="main">
      <div class="pane">
        <div class="controls">
          <button type="submit">Run</button>
          <button type="button" onclick="clearAll()">Clear All</button>
        </div>
        <textarea id="codeArea" name="code" rows="12" placeholder="Write your code here... <br> Name your main class as Program"><%= request.getParameter("code") != null ? request.getParameter("code") : "" %></textarea>
      </div>

      <div class="pane">
        <textarea id="inputArea" name="input" rows="3" placeholder="Your program input (multi-line supported)..."><%= request.getParameter("input") != null ? request.getParameter("input") : "" %></textarea>
      </div>

      <div class="pane">
        <div class="output-title">Output</div>
        <div id="outputBox" class="output-content">
          <%= request.getAttribute("output") != null ? request.getAttribute("output") : "Output will appear here..." %>
        </div>
      </div>
    </div>
  </div>
</form>

</body>
</html>
