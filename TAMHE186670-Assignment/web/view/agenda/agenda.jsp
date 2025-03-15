<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Request</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/static/request.css" rel="stylesheet" type="text/css"/>
        <style>
            a{
                text-decoration: none;
            }

            p {
                margin: 0;
                padding: 0;
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

            .fade-out {
                animation: fadeOut 2s forwards;
            }

            @keyframes fadeOut {
                0% {
                    opacity: 1;
                }
                70% {
                    opacity: 1;
                }
                100% {
                    opacity: 0;
                    display: none;
                }
            }

            .pagger a
            {
                color: #66ccff;
                border-style: solid;
                border-width: 1px;
                border-color: #66ccff;
                padding: 5px 10px;
                margin: 5px;
                border-radius: 5px;
                transition: all 0.3s ease;
            }

            .pagger a:hover {
                color: white;
                background-color: #66ccff;
            }

            .span-pagger {
                color: white;
                background-color: #66ccff;
                padding: 6px 12px;
                margin: 6px;
                border-radius: 5px;
                transition: all 0.3s ease;
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
                <a href="${pageContext.request.contextPath}/home"><div class="nav-item">🏢 Home</div></a>
                <a href="${pageContext.request.contextPath}/leaverequest"><div class="nav-item">📅 Request</div></a>
                <a href="${pageContext.request.contextPath}/agenda"><div class="nav-item active">📊 Agenda</div></a>
            </aside>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <div class="dashboard-header">
                <h1 class="page-title">Agenda</h1>
            </div>

            <div class="welcome-container">
                <form class="input-group gap-2" action="agenda" method="get">
                    <input class="form-control" type="date" name="start" value="${start}" />
                    <input class="form-control" type="date" name="end" value="${end}" readonly=""/>
                    <button type="submit" class="btn btn-success text-white">View</button>
                </form>
            </div>

            <div class="agenda-container welcome-container">
                <table class="table text-center table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Nhân Viên</th>
                                <c:forEach items="${dateList}" var="date">
                                <th>${date}</th>
                                </c:forEach>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${eList}" var="e">
                            <tr>
                                <td>${e.name}</td>
                                <c:forEach items="${dateList}" var="date">
                                    <c:set var="isOff" value="false"/>
                                    <c:forEach items="${agenda}" var="a">
                                        <c:if test="${a.emp.id == e.id && date.equals(a.offWorkDate.toLocalDate())}">
                                            <c:set var="isOff" value="true"/>
                                        </c:if>
                                    </c:forEach>

                                    <c:choose>
                                        <c:when test="${isOff}">
                                            <td style="background-color: red;"></td>
                                        </c:when>
                                        <c:otherwise>
                                            <td style="background-color: #00bc00;"></td>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const startDate = document.querySelector('input[name="start"]');
                const endDate = document.querySelector('input[name="end"]');

                // Function to validate the date range
                function validateDateChange() {
                    // Parse the start date string to a Date object
                    let start = new Date(startDate.value);

                    // Create a new date 7 days after the start date
                    let end = new Date(start);
                    end.setDate(start.getDate() + 7);

                    // Format the end date to YYYY-MM-DD format for input value
                    let month = String(end.getMonth() + 1).padStart(2, '0');
                    let day = String(end.getDate()).padStart(2, '0');
                    let year = end.getFullYear();

                    endDate.value = year + `-` + month + `-` + day;
                }

                startDate.addEventListener('change', function () {
                    validateDateChange();
                });
            });
        </script>
    </body>
</html>