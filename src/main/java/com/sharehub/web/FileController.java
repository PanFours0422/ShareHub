package com.sharehub.web;

import com.sharehub.entity.File;
import com.sharehub.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.io.FileInputStream;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;

    private static final String UPLOAD_DIR = "uploads";

    @GetMapping("/list")
    public String toList(Model model, HttpSession session) {
        // 检查是否是管理员
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
            // 管理员查看所有文件
            List<File> files = fileService.getAllFiles();
            model.addAttribute("files", files);
            return "admin/file";
        } else {
            // 普通用户查看自己的文件
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/user/login";
            }
            List<File> files = fileService.getFilesByUserId(userId);
            model.addAttribute("files", files);
            return "file/list";
        }
    }

    @PostMapping("/upload")
    @ResponseBody
    public String uploadFile(@RequestParam("file") MultipartFile file,
                           HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "请先登录";
        }

        try {
            // 创建上传目录
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // 保存文件
            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath);

            // 保存文件信息到数据库
            File fileEntity = new File();
            fileEntity.setUserId(userId);
            fileEntity.setFileName(file.getOriginalFilename());
            fileEntity.setFilePath(filePath.toString());
            fileEntity.setFileSize(file.getSize());
            fileEntity.setFileType(file.getContentType());
            fileEntity.setStatus(1);

            if (fileService.addFile(fileEntity)) {
                return "上传成功";
            } else {
                return "上传失败";
            }
        } catch (IOException e) {
            return "上传失败：" + e.getMessage();
        }
    }

    @GetMapping("/download/{id}")
    public void downloadFile(@PathVariable Long id, HttpServletResponse response) throws IOException {
        File file = fileService.getFileById(id);
        if (file != null) {
            java.io.File physicalFile = new java.io.File(file.getFilePath());
            if (physicalFile.exists()) {
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment; filename=" + 
                    URLEncoder.encode(file.getFileName(), "UTF-8"));
                response.setContentLengthLong(physicalFile.length());
                
                try (InputStream in = new FileInputStream(physicalFile);
                     OutputStream out = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
            }
        }
    }

    @PostMapping("/delete/{id}")
    @ResponseBody
    public String deleteFile(@PathVariable Long id, HttpSession session) {
        // 检查是否是管理员
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
            // 管理员可以删除任何文件
            if (fileService.deleteFile(id)) {
                return "success";
            }
        } else {
            // 普通用户只能删除自己的文件
            Long userId = (Long) session.getAttribute("userId");
            if (userId != null) {
                File file = fileService.getFileById(id);
                if (file != null && file.getUserId().equals(userId)) {
                    if (fileService.deleteFile(id)) {
                        return "success";
                    }
                }
            }
        }
        return "删除失败";
    }
} 