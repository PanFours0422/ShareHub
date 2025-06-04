<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - ShareHub</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 100%;
            max-width: 100%;
            padding: 15px;
            margin: 0;
        }
        .login-container {
            width: 400px;
            margin: 0 auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        .form-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
            font-weight: 600;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px;
            border: 1px solid #ddd;
            width: 280px;
            margin: 0 auto;
            display: block;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            border-color: #667eea;
        }
        .btn-primary {
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            width: 200px;
            margin: 0 auto;
            display: block;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .input-group {
            margin-bottom: 1rem;
            text-align: center;
        }
        .input-group i {
            color: #667eea;
            margin-right: 8px;
            font-size: 1.1em;
        }
        .error-message {
            color: #dc3545;
            margin-top: 10px;
            text-align: center;
            display: none;
        }
        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .register-link a:hover {
            color: #764ba2;
        }
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        .logo i {
            font-size: 48px;
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <div class="logo">
                <i class="fas fa-share-alt"></i>
            </div>
            <h2 class="form-title">欢迎使用 ShareHub</h2>
            <form id="loginForm">
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" class="form-control" id="username" name="username" placeholder="用户名" required>
                </div>
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" class="form-control" id="password" name="password" placeholder="密码" required>
                </div>
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i> 登录
                    </button>
                </div>
                <div class="register-link">
                    <a href="${pageContext.request.contextPath}/user/register">
                        <i class="fas fa-user-plus"></i> 还没有账号？立即注册
                    </a>
                </div>
                <div id="errorMessage" class="error-message"></div>
            </form>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#loginForm').on('submit', function(e) {
                e.preventDefault();

                $.ajax({
                    url: '${pageContext.request.contextPath}/user/login',
                    type: 'POST',
                    data: {
                        username: $('#username').val(),
                        password: $('#password').val()
                    },
                    success: function(response) {
                        if (response === 'success') {
                            window.location.href = '${pageContext.request.contextPath}/file/list';
                        } else {
                            $('#errorMessage').text(response).show();
                        }
                    },
                    error: function() {
                        $('#errorMessage').text('登录失败，请稍后重试').show();
                    }
                });
            });
        });
    </script>
</body>
</html> 