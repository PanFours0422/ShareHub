package com.sharehub.service;

import com.sharehub.entity.File;
import java.util.List;

public interface FileService {
    /**
     * 获取所有文件
     */
    List<File> getAllFiles();
    
    /**
     * 根据ID获取文件
     */
    File getFileById(Long id);
    
    /**
     * 根据用户ID获取文件列表
     */
    List<File> getFilesByUserId(Long userId);
    
    /**
     * 添加文件
     */
    boolean addFile(File file);
    
    /**
     * 更新文件信息
     */
    boolean updateFile(File file);
    
    /**
     * 删除文件
     */
    boolean deleteFile(Long id);
} 