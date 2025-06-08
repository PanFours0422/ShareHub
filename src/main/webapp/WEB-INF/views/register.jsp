<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
        }
        
        body {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .register-container {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
        }
        
        .register-title {
            text-align: center;
            color: var(--primary-color);
            margin-bottom: 2rem;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25);
        }
        
        .btn-register {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 0.8rem;
            border-radius: 5px;
            width: 100%;
            font-weight: 500;
            margin-top: 1rem;
        }
        
        .btn-register:hover {
            background: linear-gradient(to right, var(--secondary-color), var(--primary-color));
            color: white;
        }
        
        .login-link {
            text-align: center;
            margin-top: 1rem;
        }
        
        .login-link a {
            color: var(--primary-color);
            text-decoration: none;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .input-group-text {
            background-color: white;
            border-right: none;
        }
        
        .form-control {
            border-left: none;
        }
        
        .input-group:focus-within {
            box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25);
        }
        
        .input-group:focus-within .input-group-text,
        .input-group:focus-within .form-control {
            border-color: var(--primary-color);
        }
        
        .verification-code-group {
            display: flex;
            gap: 10px;
        }
        
        .verification-code-group .form-control {
            flex: 1;
        }
        
        .verification-code-group .btn {
            width: 120px;
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2 class="register-title">
            <i class="fas fa-user-plus"></i> 注册账号
        </h2>
        <form id="registerForm">
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-user"></i>
                    </span>
                    <input type="text" class="form-control" id="username" name="username" placeholder="用户名" required>
                </div>
                <div class="invalid-feedback" id="usernameFeedback"></div>
            </div>
            
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-envelope"></i>
                    </span>
                    <input type="email" class="form-control" id="email" name="email" placeholder="邮箱" required>
                </div>
                <div class="invalid-feedback" id="emailFeedback"></div>
            </div>
            
            <div class="mb-3">
                <div class="input-group verification-code-group">
                    <span class="input-group-text">
                        <i class="fas fa-phone"></i>
                    </span>
                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="手机号码" required>
                    <button type="button" class="btn btn-outline-primary" id="sendCodeBtn">获取验证码</button>
                </div>
                <div class="invalid-feedback" id="phoneFeedback"></div>
            </div>
            
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-shield-alt"></i>
                    </span>
                    <input type="text" class="form-control" id="verificationCode" name="verificationCode" placeholder="验证码" required>
                </div>
                <div class="invalid-feedback" id="verificationCodeFeedback"></div>
            </div>
            
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-lock"></i>
                    </span>
                    <input type="password" class="form-control" id="password" name="password" placeholder="密码" required>
                </div>
                <div class="invalid-feedback" id="passwordFeedback"></div>
            </div>
            
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-lock"></i>
                    </span>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="确认密码" required>
                </div>
                <div class="invalid-feedback" id="confirmPasswordFeedback"></div>
            </div>
            
            <button type="submit" class="btn btn-register">注册</button>
        </form>
        
        <div class="login-link">
            已有账号？<a href="${pageContext.request.contextPath}/user/login">立即登录</a>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            // 用户名验证
            $('#username').on('blur', function() {
                var username = $(this).val();
                if (username.length < 3) {
                    $(this).addClass('is-invalid');
                    $('#usernameFeedback').text('用户名至少需要3个字符');
                    return;
                }
                
                $.post('${pageContext.request.contextPath}/user/checkUsername', {username: username}, function(response) {
                    if (response === 'exists') {
                        $('#username').addClass('is-invalid');
                        $('#usernameFeedback').text('用户名已存在');
                    } else {
                        $('#username').removeClass('is-invalid').addClass('is-valid');
                        $('#usernameFeedback').text('');
                    }
                });
            });
            
            // 邮箱验证
            $('#email').on('blur', function() {
                var email = $(this).val();
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                
                if (!emailRegex.test(email)) {
                    $(this).addClass('is-invalid');
                    $('#emailFeedback').text('请输入有效的邮箱地址');
                    return;
                }
                
                $.post('${pageContext.request.contextPath}/user/checkEmail', {email: email}, function(response) {
                    if (response === 'exists') {
                        $('#email').addClass('is-invalid');
                        $('#emailFeedback').text('邮箱已被注册');
                    } else {
                        $('#email').removeClass('is-invalid').addClass('is-valid');
                        $('#emailFeedback').text('');
                    }
                });
            });
            
            // 手机号验证
            $('#phone').on('blur', function() {
                var phone = $(this).val();
                var phoneRegex = /^1[3-9]\d{9}$/;
                
                if (!phoneRegex.test(phone)) {
                    $(this).addClass('is-invalid');
                    $('#phoneFeedback').text('请输入有效的手机号码');
                    return;
                }
                
                $.post('${pageContext.request.contextPath}/user/checkPhone', {phone: phone}, function(response) {
                    if (response === 'exists') {
                        $('#phone').addClass('is-invalid');
                        $('#phoneFeedback').text('手机号已被注册');
                    } else {
                        $('#phone').removeClass('is-invalid').addClass('is-valid');
                        $('#phoneFeedback').text('');
                    }
                });
            });
            
            // 发送验证码
            $('#sendCodeBtn').on('click', function() {
                var phone = $('#phone').val();
                var phoneRegex = /^1[3-9]\d{9}$/;
                
                if (!phoneRegex.test(phone)) {
                    $('#phone').addClass('is-invalid');
                    $('#phoneFeedback').text('请输入有效的手机号码');
                    return;
                }
                
                var $btn = $(this);
                $btn.prop('disabled', true);
                var countdown = 60;
                
                $.post('${pageContext.request.contextPath}/user/sendCode', {phone: phone}, function(response) {
                    if (response === 'success') {
                        var timer = setInterval(function() {
                            if (countdown > 0) {
                                $btn.text(countdown + '秒后重试');
                                countdown--;
                            } else {
                                clearInterval(timer);
                                $btn.prop('disabled', false).text('获取验证码');
                            }
                        }, 1000);
                    } else {
                        alert(response);
                        $btn.prop('disabled', false);
                    }
                });
            });
            
            // 验证码验证
            $('#verificationCode').on('blur', function() {
                var code = $(this).val();
                var phone = $('#phone').val();
                
                if (code.length !== 6) {
                    $(this).addClass('is-invalid');
                    $('#verificationCodeFeedback').text('请输入6位验证码');
                    return;
                }
                
                $.post('${pageContext.request.contextPath}/user/verifyCode', {
                    phone: phone,
                    code: code
                }, function(response) {
                    if (response === 'success') {
                        $('#verificationCode').removeClass('is-invalid').addClass('is-valid');
                        $('#verificationCodeFeedback').text('');
                    } else {
                        $('#verificationCode').addClass('is-invalid');
                        $('#verificationCodeFeedback').text(response);
                    }
                });
            });
            
            // 密码验证
            $('#password').on('input', function() {
                var password = $(this).val();
                if (password.length < 6) {
                    $(this).addClass('is-invalid');
                    $('#passwordFeedback').text('密码至少需要6个字符');
                } else {
                    $(this).removeClass('is-invalid').addClass('is-valid');
                    $('#passwordFeedback').text('');
                }
            });
            
            // 确认密码验证
            $('#confirmPassword').on('input', function() {
                var password = $('#password').val();
                var confirmPassword = $(this).val();
                
                if (password !== confirmPassword) {
                    $(this).addClass('is-invalid');
                    $('#confirmPasswordFeedback').text('两次输入的密码不一致');
                } else {
                    $(this).removeClass('is-invalid').addClass('is-valid');
                    $('#confirmPasswordFeedback').text('');
                }
            });
            
            // 表单提交
            $('#registerForm').on('submit', function(e) {
                e.preventDefault();
                
                // 验证所有字段
                var username = $('#username').val();
                var email = $('#email').val();
                var phone = $('#phone').val();
                var verificationCode = $('#verificationCode').val();
                var password = $('#password').val();
                var confirmPassword = $('#confirmPassword').val();
                
                if (!username || !email || !phone || !verificationCode || !password || !confirmPassword) {
                    alert('请填写所有必填字段');
                    return;
                }
                
                if (password !== confirmPassword) {
                    alert('两次输入的密码不一致');
                    return;
                }
                
                // 发送注册请求
                $.post('${pageContext.request.contextPath}/user/register', {
                    username: username,
                    email: email,
                    phone: phone,
                    password: password,
                    confirmPassword: confirmPassword,
                    verificationCode: verificationCode
                }, function(response) {
                    if (response === 'success') {
                        alert('注册成功！');
                        window.location.href = '${pageContext.request.contextPath}/user/login';
                    } else {
                        alert(response);
                    }
                });
            });
        });
    </script>
</body>
</html>