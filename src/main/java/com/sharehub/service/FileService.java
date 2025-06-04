package com.sharehub.service;

import com.sharehub.entity.File;
import java.util.List;

public interface FileService {
    /**
     * 上传文件
     * @param file 文件信息
     * @return 文件ID
     */
    Long uploadFile(File file);

    /**
     * 获取文件信息
     * @param id 文件ID
     * @return 文件信息
     */
    File getFileById(Long id);

    /**
     * 获取用户的文件列表
     * @param userId 用户ID
     * @return 文件列表
     */
    List<File> getUserFiles(Long userId);

    /**
     * 分页获取用户的文件列表
     * @param userId 用户ID
     * @param page 页码
     * @param size 每页大小
     * @return 文件列表
     */
    List<File> getUserFilesByPage(Long userId, int page, int size);

    /**
     * 获取用户文件总数
     * @param userId 用户ID
     * @return 文件总数
     */
    int getUserFileCount(Long userId);

    /**
     * 更新文件状态
     * @param id 文件ID
     * @param status 状态
     */
    void updateFileStatus(Long id, int status);

    /**
     * 删除文件
     * @param id 文件ID
     */
    void deleteFile(Long id);
} 