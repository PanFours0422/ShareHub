package com.sharehub.service.impl;

import com.sharehub.entity.File;
import com.sharehub.mapper.FileMapper;
import com.sharehub.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class FileServiceImpl implements FileService {

    @Autowired
    private FileMapper fileMapper;

    @Override
    @Transactional
    public Long uploadFile(File file) {
        fileMapper.insert(file);
        return file.getId();
    }

    @Override
    public File getFileById(Long id) {
        return fileMapper.selectById(id);
    }

    @Override
    public List<File> getUserFiles(Long userId) {
        return fileMapper.selectByUserId(userId);
    }

    @Override
    public List<File> getUserFilesByPage(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        return fileMapper.selectPage(userId, offset, size);
    }

    @Override
    public int getUserFileCount(Long userId) {
        return fileMapper.countByUserId(userId);
    }

    @Override
    @Transactional
    public void updateFileStatus(Long id, int status) {
        fileMapper.updateStatus(id, status);
    }

    @Override
    @Transactional
    public void deleteFile(Long id) {
        fileMapper.deleteById(id);
    }
} 