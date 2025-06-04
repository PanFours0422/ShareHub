<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - ShareHub</title>
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
        .register-container {
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
        .input-group {
            margin-bottom: 1rem;
            text-align: center;
        }
        .input-group i {
            color: #667eea;
            margin-right: 8px;
            font-size: 1.1em;
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
        .form-floating {
            margin-bottom: 1rem;
        }
        .error-message {
            color: #dc3545;
            margin-top: 10px;
            text-align: center;
            display: none;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .login-link a:hover {
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
        .form-text {
            color: #6c757d;
            font-size: 0.875em;
            margin-top: 0.25rem;
        }
        .password-strength {
            height: 5px;
            margin-top: 5px;
            border-radius: 3px;
            transition: all 0.3s ease;
        }
        .strength-weak {
            background-color: #dc3545;
            width: 33%;
        }
        .strength-medium {
            background-color: #ffc107;
            width: 66%;
        }
        .strength-strong {
            background-color: #28a745;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <div class="logo">
                <i class="fas fa-share-alt"></i>
            </div>
            <h2 class="form-title">创建您的 ShareHub 账号</h2>
            <form id="registerForm" method="post">
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" class="form-control" id="username" name="username" placeholder="用户名" required>
                    <div class="form-text" id="usernameFeedback"></div>
                </div>
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" class="form-control" id="email" name="email" placeholder="邮箱" required>
                    <div class="form-text" id="emailFeedback"></div>
                </div>
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" class="form-control" id="password" name="password" placeholder="密码" required>
                    <div class="password-strength"></div>
                </div>
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" class="form-control" id="confirmPassword" placeholder="确认密码" required>
                </div>
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i> 注册
                    </button>
                </div>
                <div class="login-link">
                    <a href="${pageContext.request.contextPath}/user/login">
                        <i class="fas fa-sign-in-alt"></i> 已有账号？立即登录
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
            // 检查用户名是否可用
            $('#username').on('blur', function() {
                var username = $(this).val();
                if (username) {
                    $.get('${pageContext.request.contextPath}/user/checkUsername', {username: username}, function(response) {
                        if (response === 'exists') {
                            $('#usernameFeedback').text('用户名已被使用').css('color', 'red');
                        } else {
                            $('#usernameFeedback').text('用户名可用').css('color', 'green');
                        }
                    });
                }
            });

            // 检查邮箱是否可用
            $('#email').on('blur', function() {
                var email = $(this).val();
                if (email) {
                    $.get('${pageContext.request.contextPath}/user/checkEmail', {email: email}, function(response) {
                        if (response === 'exists') {
                            $('#emailFeedback').text('邮箱已被注册').css('color', 'red');
                        } else {
                            $('#emailFeedback').text('邮箱可用').css('color', 'green');
                        }
                    });
                }
            });

            // 密码强度检测
            $('#password').on('input', function() {
                var password = $(this).val();
                var strength = $('.password-strength');
                
                if (password.length === 0) {
                    strength.removeClass('strength-weak strength-medium strength-strong');
                    return;
                }
                
                var hasLetter = /[A-Za-z]/.test(password);
                var hasNumber = /[0-9]/.test(password);
                var hasSpecial = /[!@#$%^&*]/.test(password);
                
                strength.removeClass('strength-weak strength-medium strength-strong');
                
                if (password.length < 6) {
                    strength.addClass('strength-weak');
                } else if (hasLetter && hasNumber) {
                    if (hasSpecial) {
                        strength.addClass('strength-strong');
                    } else {
                        strength.addClass('strength-medium');
                    }
                } else {
                    strength.addClass('strength-weak');
                }
            });

            // 表单提交
            $('#registerForm').on('submit', function(e) {
                e.preventDefault();
                
                // 验证密码
                if ($('#password').val() !== $('#confirmPassword').val()) {
                    $('#errorMessage').text('两次输入的密码不一致').show();
                    return false;
                }

                // 验证密码强度
                var password = $('#password').val();
                if (password.length < 6 || !/[A-Za-z]/.test(password) || !/[0-9]/.test(password)) {
                    $('#errorMessage').text('密码必须至少6位，包含字母和数字').show();
                    return false;
                }

                // 发送注册请求
                $.ajax({
                    url: '${pageContext.request.contextPath}/user/register',
                    type: 'POST',
                    data: {
                        username: $('#username').val(),
                        email: $('#email').val(),
                        password: $('#password').val()
                    },
                    success: function(response) {
                        console.log('注册响应:', response);
                        if (response === 'success') {
                            alert('注册成功！');
                            window.location.href = '${pageContext.request.contextPath}/user/login';
                        } else {
                            $('#errorMessage').text(response).show();
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('注册错误:', error);
                        $('#errorMessage').text('注册失败，请稍后重试').show();
                    }
                });
                
                return false;
            });
        });
    </script>
</body>
</html> 