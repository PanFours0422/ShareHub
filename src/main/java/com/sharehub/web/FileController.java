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
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;

    private static final String UPLOAD_DIR = "uploads";

    @GetMapping("/list")
    public String listFiles(HttpSession session, Model model,
                          @RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/user/login";
        }

        List<File> files = fileService.getUserFilesByPage(userId, page, size);
        int total = fileService.getUserFileCount(userId);
        int totalPages = (int) Math.ceil((double) total / size);

        model.addAttribute("files", files);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        return "file/list";
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

            fileService.uploadFile(fileEntity);
            return "上传成功";
        } catch (IOException e) {
            return "上传失败：" + e.getMessage();
        }
    }

    @GetMapping("/download/{id}")
    public void downloadFile(@PathVariable Long id,
                           HttpSession session,
                           javax.servlet.http.HttpServletResponse response) throws IOException {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            response.sendError(401, "请先登录");
            return;
        }

        File file = fileService.getFileById(id);
        if (file == null || !file.getUserId().equals(userId)) {
            response.sendError(404, "文件不存在");
            return;
        }

        Path filePath = Paths.get(file.getFilePath());
        if (!Files.exists(filePath)) {
            response.sendError(404, "文件不存在");
            return;
        }

        response.setContentType(file.getFileType());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getFileName() + "\"");
        Files.copy(filePath, response.getOutputStream());
    }

    @PostMapping("/delete/{id}")
    @ResponseBody
    public String deleteFile(@PathVariable Long id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "请先登录";
        }

        File file = fileService.getFileById(id);
        if (file == null || !file.getUserId().equals(userId)) {
            return "文件不存在";
        }

        try {
            // 删除物理文件
            Path filePath = Paths.get(file.getFilePath());
            Files.deleteIfExists(filePath);

            // 删除数据库记录
            fileService.deleteFile(id);
            return "删除成功";
        } catch (IOException e) {
            return "删除失败：" + e.getMessage();
        }
    }
} 