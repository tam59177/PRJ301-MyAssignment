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
                <div class="nav-item active">📅 Request</div>
                <a href="${pageContext.request.contextPath}/agenda"><div class="nav-item">📊 Agenda</div></a>
            </aside>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <div class="dashboard-header">
                <h1 class="page-title">Request</h1>
            </div>

            <c:if test="${not empty errmessage}">
                <div class="alert fade-out alert-danger" role="alert">
                    <p>${errmessage}</p>
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert fade-out alert-success" role="alert">
                    <p>${message}</p>
                </div>
            </c:if>

            <!-- Recent Contacts Table -->
            <div class="welcome-container">
                <div class="btn btn-primary">
                    <a href="#" class="text-light" data-bs-toggle="modal" data-bs-target="#createRequestModal">Create Leave Request</a>
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
                                    <th>Action</th>
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
                                        <td><a href="${pageContext.request.contextPath}/leaverequest/detail?lrid=${l.id}">See detail</a></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div id="botpagger" class="pagger"></div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center">No Leave Request Yet! Good Jobs</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <!-- Create Request Modal -->
        <div class="modal fade" id="createRequestModal" tabindex="-1" aria-labelledby="createRequestModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="createRequestModalLabel">Create Leave Request</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="${pageContext.request.contextPath}/leaverequest/create" method="POST" onsubmit="return validateForm(event)">
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
                                <label for="from" class="form-label">From Date</label>
                                <input type="date" class="form-control" id="from" name="from" required>
                            </div>

                            <!-- To Date -->
                            <div class="mb-3">
                                <label for="to" class="form-label">To Date</label>
                                <input type="date" class="form-control" id="to" name="to" required>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Submit Request</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            pagger('botpagger',${requestScope.pageindex},${requestScope.totalpage}, 2);

                            // Show modal automatically if there was an error submitting the form
                            document.addEventListener('DOMContentLoaded', function () {
                                // Handle fadeout and removal of alerts after animation completes
                                const alerts = document.querySelectorAll('.alert.fade-out');

                                alerts.forEach(alert => {
                                    setTimeout(() => {
                                        alert.style.display = 'none';
                                    }, 2000); // Remove from DOM after 2 seconds
                                });
                            });

                            function validateForm(event) {
                                let fromDateValue = document.getElementById("from").value;
                                let toDateValue = document.getElementById("to").value;

                                let today = new Date();
                                today.setHours(0, 0, 0, 0); // Remove time portion for accurate comparison

                                if (fromDateValue) {
                                    let fromDateObj = new Date(fromDateValue);

                                    // Check if "From Date" is greater than today
                                    if (fromDateObj <= today) {
                                        alert("Error: 'From Date' must be greater than today.");
                                        event.preventDefault();
                                        return false;
                                    }

                                    // Check if "To Date" is greater than "From Date"
                                    if (toDateValue) {
                                        let toDateObj = new Date(toDateValue);
                                        if (toDateObj < fromDateObj) {
                                            alert("Error: 'To Date' must be greater than 'From Date'.");
                                            event.preventDefault();
                                            return false;
                                        }
                                    }
                                }

                                return true;
                            }

                            function pagger(id, pageindex, totalpage, gap)
                            {
                                var container = document.getElementById(id);
                                var content = '';

                                if (pageindex > gap + 1)
                                    content += '<a href="${pageContext.request.contextPath}/leaverequest?page=1">First</a>';

                                if (pageindex - gap > 2)
                                    content += '<span>...</span>';

                                for (var i = pageindex - gap; i < pageindex; i++)
                                {
                                    if (i > 0)
                                        content += '<a href="${pageContext.request.contextPath}/leaverequest?page=' + i + '">' + i + '</a>';
                                }

                                content += '<span class=\"span-pagger\">' + pageindex + '</span>';

                                for (var i = pageindex + 1; i <= pageindex + gap; i++)
                                {
                                    if (i <= totalpage)
                                        content += '<a href="${pageContext.request.contextPath}/leaverequest?page=' + i + '">' + i + '</a>';
                                }

                                if (pageindex + gap <= totalpage - 2)
                                    content += '<span>...</span>';

                                if (pageindex < totalpage - gap)
                                    content += '<a href="${pageContext.request.contextPath}/leaverequest?page=' + totalpage + '">Last</a>';

                                container.innerHTML = content;

                            }
        </script>
    </body>
</html>