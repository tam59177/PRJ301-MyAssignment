<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Request</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="/assignment/css/static/detail.css" rel="stylesheet" type="text/css"/>
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

            <c:if test="${not empty message}">
                <div class="alert alert-danger" role="alert">
                    <p>${message}</p>
                </div>
            </c:if>

            <!-- Recent Contacts Table -->
            <div class="welcome-container">
                <div class="btn btn-info">
                    <a href="${pageContext.request.contextPath}/leaverequest" class="text-light">Back</a>
                </div>
                <div class="btn btn-primary">
                    <a href="${pageContext.request.contextPath}/leaverequest/edit?type=all" class="text-light">Edit Leave Request</a>
                </div>
                <div class="btn btn-danger">
                    <a href="${pageContext.request.contextPath}/leaverequest/delete" class="text-light">Delete Leave Request</a>
                </div>
            </div>

            <div class="request-detail-container d-flex justify-content-center">
                <form action="" method="">
                    <div class="detail-main">
                        <div class="detail-header text-center">
                            <h4>Tâm xin nghỉ học</h4>
                        </div>
                        <div class="detail-body d-flex justify-content-center gap-5">
                            <div class="">
                                <h5>Reason: Tam xin nghi học</h5>
                                <p>From: 12-03-2025</p>
                                <p>To: 16-03-2025</p>
                                <p>Status: Inprogress</p>
                            </div>
                            <div class="">
                                <p>Created By: Tam</p>
                                <p>Created Date: 2025-03-11 15:22:59.210</p>
                            </div>
                        </div>
                        <div class="detail-footer text-center">
                            <div class="btn btn-success">
                                <a href="${pageContext.request.contextPath}/leaverequest/edit?type=state" class="text-light">Approve</a>
                            </div>
                            <div class="btn btn-danger">
                                <a href="${pageContext.request.contextPath}/leaverequest/edit?type=state" class="text-light">Reject</a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            pagger('botpagger',${requestScope.pageindex},${requestScope.totalpage}, 2);
        </script>
    </body>
</html>