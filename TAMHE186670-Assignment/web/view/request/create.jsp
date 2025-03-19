<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Request</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            a{
                text-decoration: none;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                display: grid;
                grid-template-areas:
                    "header header"
                    "sidebar main";
                grid-template-columns: 250px 1fr;
                grid-template-rows: 60px 1fr;
                height: 100vh;
                background-color: #f5f7fa;
            }

            header {
                grid-area: header;
                background-color: #ffffff;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 20px;
                z-index: 10;
            }

            .logo {
                font-weight: bold;
                font-size: 1.5rem;
                color: #3a6ff7;
            }

            .header-right {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .search-bar {
                padding: 8px 15px;
                border-radius: 4px;
                border: 1px solid #e0e0e0;
                background-color: #f5f5f5;
                width: 250px;
            }

            .sidebar {
                grid-area: sidebar;
                background-color: #ffffff;
                padding: 20px 0;
                box-shadow: 2px 0 4px rgba(0,0,0,0.05);
                overflow-y: auto;
            }

            .nav-item {
                padding: 12px 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                color: #555;
                cursor: pointer;
                transition: all 0.2s;
            }

            .nav-item:hover, .nav-item.active {
                background-color: #f0f5ff;
                color: #3a6ff7;
                border-left: 3px solid #3a6ff7;
            }

            .nav-item.active {
                font-weight: bold;
            }

            .main-content {
                grid-area: main;
                padding: 20px;
                overflow-y: auto;
            }

            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .page-title {
                font-size: 1.5rem;
                color: #333;
            }

            .welcome-container, .request-container {
                background-color: white;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.05);
                text-align: left;
                margin-bottom: 10px;
            }

            .display-name {
                font-size: 20px;
                font-weight: bold;
            }

            .button {
                text-align: center;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header>
            <a href="${pageContext.request.contextPath}/home"><div class="logo">CRM System</div></a>
            <div class="header-right">
                <div class="display-name">Hello, ${sessionScope.user.displayname}</div>
                <div class="logout btn btn-primary"><a href="${pageContext.request.contextPath}/logout" class="text-light">Log Out</a></div>
            </div>
        </header>

        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <aside class="sidebar">
                <a href="${pageContext.request.contextPath}/home"><div class="nav-item">📊 Home</div></a>
                <a href="${pageContext.request.contextPath}/leaverequest"><div class="nav-item">📅 Request</div></a>
            </aside>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <div class="dashboard-header">
                <h1 class="page-title">Request</h1>
            </div>

            <div class="request-container">
                <form action="${pageContext.request.contextPath}/leaverequest/create" method="POST">

                    <!-- Title -->
                    <div class="mb-3">
                        <label for="title" class="form-label">Title</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>

                    <!-- Reason -->
                    <div class="mb-3">
                        <label for="reason" class="form-label">Reason</label>
                        <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
                    </div>

                    <!-- From Date -->
                    <div class="mb-3">
                        <label for="fromDate" class="form-label">From Date</label>
                        <input type="date" class="form-control" id="from" name="from" required>
                    </div>

                    <!-- To Date -->
                    <div class="mb-3">
                        <label for="toDate" class="form-label">To Date</label>
                        <input type="date" class="form-control" id="to" name="to" required>
                    </div>

                    <!-- Submit Button -->
                    <div class="button">
                        <button type="submit" class="btn btn-primary">Submit Request</button>
                    </div>

                </form>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let fromDate = document.getElementById("from");
                let toDate = document.getElementById("to");

                function validateDates() {
                    let fromDateValue = new Date(fromDate.value);
                    let toDateValue = new Date(toDate.value);

                    if (toDate.value && fromDate.value && toDateValue < fromDateValue) {
                        alert("From date must be smaller than to date");
                        toDate.value = ""; // Reset toDate if it's invalid
                    }
                }

                fromDate.addEventListener("change", validateDates);
                toDate.addEventListener("change", validateDates);
            });
        </script>
    </body>
</html>