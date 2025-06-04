<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的文件 - ShareHub</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --hover-color: #f8f9fa;
        }
        
        body {
            background-color: #f5f7fa;
            min-height: 100vh;
        }
        
        .navbar {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            color: white !important;
            font-weight: 600;
        }
        
        .nav-link {
            color: rgba(255,255,255,0.9) !important;
        }
        
        .nav-link:hover {
            color: white !important;
        }
        
        .main-container {
            padding: 2rem;
        }
        
        .file-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1.5rem;
            padding: 1rem 0;
        }
        
        .file-card {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .file-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .file-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
            text-align: center;
        }
        
        .file-name {
            font-size: 0.9rem;
            color: #333;
            text-align: center;
            word-break: break-all;
            margin-bottom: 0.5rem;
        }
        
        .file-info {
            font-size: 0.8rem;
            color: #666;
            text-align: center;
        }
        
        .file-actions {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            display: none;
        }
        
        .file-card:hover .file-actions {
            display: block;
        }
        
        .action-btn {
            background: none;
            border: none;
            color: #666;
            padding: 0.25rem;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        
        .action-btn:hover {
            color: var(--primary-color);
        }
        
        .upload-btn {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            padding: 0.5rem 1.5rem;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .upload-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
            color: white;
        }
        
        .breadcrumb {
            background: white;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .search-box {
            background: white;
            border-radius: 5px;
            padding: 0.5rem 1rem;
            border: 1px solid #ddd;
            width: 300px;
        }
        
        .search-box:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25);
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-share-alt"></i> ShareHub
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#"><i class="fas fa-folder"></i> 我的文件</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-share-alt"></i> 分享</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <span class="text-white me-3">
                        <i class="fas fa-user"></i> ${sessionScope.username}
                    </span>
                    <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-outline-light btn-sm">
                        <i class="fas fa-sign-out-alt"></i> 退出
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="#"><i class="fas fa-home"></i></a></li>
                        <li class="breadcrumb-item active">我的文件</li>
                    </ol>
                </nav>
                <div class="d-flex gap-3">
                    <input type="text" class="search-box" placeholder="搜索文件...">
                    <button class="upload-btn" onclick="document.getElementById('fileInput').click()">
                        <i class="fas fa-upload"></i> 上传文件
                    </button>
                    <input type="file" id="fileInput" style="display: none" multiple>
                </div>
            </div>

            <div class="file-grid">
                <c:forEach items="${files}" var="file">
                    <div class="file-card">
                        <div class="file-actions">
                            <button class="action-btn" title="分享">
                                <i class="fas fa-share-alt"></i>
                            </button>
                            <button class="action-btn" title="下载">
                                <i class="fas fa-download"></i>
                            </button>
                            <button class="action-btn" title="删除">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                        <div class="file-icon">
                            <c:choose>
                                <c:when test="${file.type == 'image'}">
                                    <i class="fas fa-image"></i>
                                </c:when>
                                <c:when test="${file.type == 'document'}">
                                    <i class="fas fa-file-alt"></i>
                                </c:when>
                                <c:when test="${file.type == 'video'}">
                                    <i class="fas fa-video"></i>
                                </c:when>
                                <c:when test="${file.type == 'audio'}">
                                    <i class="fas fa-music"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-file"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="file-name">${file.name}</div>
                        <div class="file-info">
                            ${file.size} · ${file.uploadTime}
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty files}">
                <div class="empty-state">
                    <i class="fas fa-folder-open"></i>
                    <h4>暂无文件</h4>
                    <p>点击上方的"上传文件"按钮开始使用</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            // 文件上传处理
            $('#fileInput').on('change', function(e) {
                var files = e.target.files;
                var formData = new FormData();
                
                for (var i = 0; i < files.length; i++) {
                    formData.append('files', files[i]);
                }
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/file/upload',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        if (response === 'success') {
                            location.reload();
                        } else {
                            alert('上传失败：' + response);
                        }
                    },
                    error: function() {
                        alert('上传失败，请稍后重试');
                    }
                });
            });

            // 文件操作处理
            $('.action-btn').on('click', function(e) {
                e.stopPropagation();
                var action = $(this).attr('title');
                var fileCard = $(this).closest('.file-card');
                var fileName = fileCard.find('.file-name').text();
                
                switch(action) {
                    case '分享':
                        // 实现分享功能
                        break;
                    case '下载':
                        window.location.href = '${pageContext.request.contextPath}/file/download?filename=' + encodeURIComponent(fileName);
                        break;
                    case '删除':
                        if (confirm('确定要删除文件 "' + fileName + '" 吗？')) {
                            $.post('${pageContext.request.contextPath}/file/delete', {
                                filename: fileName
                            }, function(response) {
                                if (response === 'success') {
                                    fileCard.fadeOut();
                                } else {
                                    alert('删除失败：' + response);
                                }
                            });
                        }
                        break;
                }
            });

            // 搜索功能
            $('.search-box').on('input', function() {
                var searchText = $(this).val().toLowerCase();
                $('.file-card').each(function() {
                    var fileName = $(this).find('.file-name').text().toLowerCase();
                    $(this).toggle(fileName.includes(searchText));
                });
            });
        });
    </script>
</body>
</html> 