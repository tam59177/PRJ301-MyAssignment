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
        <link href="css/static/request.css" rel="stylesheet" type="text/css"/>
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
                                        <td><a href="leaverequest/detail?lrid=${l.id}">See detail</a></td>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            pagger('botpagger',${requestScope.pageindex},${requestScope.totalpage}, 2);
        </script>
    </body>
</html>