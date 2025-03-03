<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>CRM - Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                height: 100vh;
                display: flex;
                align-items: center;
                background-color: #f5f5f5;
            }
            .form-signin {
                max-width: 330px;
                padding: 15px;
            }
            .form-signin .form-floating:focus-within {
                z-index: 2;
            }
            .form-signin input[type="text"] {
                margin-bottom: -1px;
                border-bottom-right-radius: 0;
                border-bottom-left-radius: 0;
            }
            .form-signin input[type="password"] {
                margin-bottom: 10px;
                border-top-left-radius: 0;
                border-top-right-radius: 0;
            }
            .login-box {
                background-color: white;
                padding: 20px;
                border-radius: 10px;
                width: 100%;
                height: auto;
                box-shadow: 0 0 10px 0 #ccc;
            }
        </style>
    </head>
    <body class="text-center">
        <main class="form-signin w-100 m-auto">
            <c:if test="${not empty message}">
                <div class="alert alert-danger" role="alert">
                    <p>${message}</p>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="login-box">
                    <img class="mb-4" src="${pageContext.request.contextPath}/img/logo.png" alt="" width="72" height="72">
                    <h1 class="h3 mb-3 fw-normal">Login</h1>

                    <div class="form-floating">
                        <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                        <label for="username">Username</label>
                    </div>
                    <div class="form-floating">
                        <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                        <label for="password">Password</label>
                    </div>
                    <div class="mb-2">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember Me</label>
                    </div>
                    <button class="w-100 btn btn-lg btn-secondary" type="submit" value="login">Sign in</button>
                </div>
                <p class="mt-5 mb-3 text-muted">&copy; 2025</p>
            </form>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>