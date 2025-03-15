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
                <a href="${pageContext.request.contextPath}/home"><div class="nav-item">🏢 Home</div></a>
                <div class="nav-item active">📅 Request</div>
                <a href="${pageContext.request.contextPath}/agenda"><div class="nav-item">📊 Agenda</div></a>
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
                    <a href="#" class="text-light" data-bs-toggle="modal" data-bs-target="#updateRequestModal">Edit Leave Request</a>
                </div>
                <div class="btn btn-danger">
                    <a href="${pageContext.request.contextPath}/leaverequest/delete" class="text-light">Delete Leave Request</a>
                </div>
            </div>

            <div class="request-detail-container d-flex justify-content-center">
                <div class="detail-main">
                    <div class="detail-header text-center">
                        <h4>${lr.title}</h4>
                    </div>
                    <div class="detail-body d-flex justify-content-center gap-5">
                        <div class="">
                            <h5>Reason: ${lr.reason}</h5>
                            <p>From: ${lr.from}</p>
                            <p>To: ${lr.to}</p>
                            <p>Status: ${lr.status}</p>
                        </div>
                        <div class="">
                            <p>Created By: ${lr.createdby.username}</p>
                            <p>Created Date: ${lr.createddate}</p>
                        </div>
                    </div>
                    <c:if test="${canManage == true}">
                        <div class="detail-footer text-center d-flex gap-2 justify-content-center">
                            <form action="${pageContext.request.contextPath}/leaverequest/update" method="POST">
                                <input type="hidden" name="type" value="state" />
                                <input type="hidden" name="state" value="Approved" />
                                <input type="hidden" name="lrid" value="${lr.id}" />
                                <button type="submit" class="btn btn-success">Approve</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/leaverequest/update" method="POST">
                                <input type="hidden" name="type" value="state" />
                                <input type="hidden" name="state" value="Rejected" />
                                <input type="hidden" name="lrid" value="${lr.id}" />
                                <button type="submit" class="btn btn-danger">Reject</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>

        <!-- Update Request Modal -->
        <div class="modal fade" id="updateRequestModal" tabindex="-1" aria-labelledby="updateRequestModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateRequestModalLabel">Update Leave Request</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="${pageContext.request.contextPath}/leaverequest/update" method="POST">
                            <input type="hidden" name="lrid" value="${lr.id}" />
                            <input type="hidden" name="type" value="all" />

                            <!-- Title -->
                            <div class="mb-3">
                                <label for="title" class="form-label">Title</label>
                                <input type="text" class="form-control" id="title" name="title" value="${lr.title}" required>
                            </div>

                            <!-- Reason -->
                            <div class="mb-3">
                                <label for="reason" class="form-label">Reason</label>
                                <textarea class="form-control" id="reason" name="reason" rows="3" required>${lr.reason}</textarea>
                            </div>

                            <!-- From Date -->
                            <div class="mb-3">
                                <label for="from" class="form-label">From Date</label>
                                <input type="date" class="form-control" id="from" name="from" value="${lr.from}" required>
                            </div>

                            <!-- To Date -->
                            <div class="mb-3">
                                <label for="to" class="form-label">To Date</label>
                                <input type="date" class="form-control" id="to" name="to" value="${lr.to}" required>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Update</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>