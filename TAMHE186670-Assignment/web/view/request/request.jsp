<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Request</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="js/control/pagger.js" type="text/javascript"></script>
        <link href="css/control/pagger.css" rel="stylesheet" type="text/css"/>
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
                <div class="nav-item active">📅 Request</div>
            </aside>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <div class="dashboard-header">
                <h1 class="page-title">Request</h1>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-danger" role="alert">
                    <p>${message}</p>
                </div>
            </c:if>

            <!-- Recent Contacts Table -->
            <div class="welcome-container">
                <div class="btn btn-primary">
                    <a href="${pageContext.request.contextPath}/leaverequest/create" class="text-light">Create Leave Request</a>
                </div>
            </div>

            <div class="request-container">
                <c:choose>
                    <c:when test="${not empty lrList}">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>From</th>
                                    <th>To</th>
                                    <th>Created By</th>
                                    <th>Status</th>
                                    <th>Processed By</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${lrList}" var="l">
                                    <tr>
                                        <td>${l.id}</td>
                                        <td>${l.title}</td>
                                        <td>${l.from}</td>
                                        <td>${l.to}</td>
                                        <td>${l.createdby.username}</td>
                                        <td>${l.status}</td>
                                        <td>${l.processedby.username}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div id="botpagger" class="pagger"></div>
                    </c:when>
                    <c:otherwise>
                        <p calss="text-center">No Leave Request Yet! Good Jobs</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            pagger('botpagger',${requestScope.pageindex},${requestScope.totalpage}, 2);
        </script>
    </body>
</html>