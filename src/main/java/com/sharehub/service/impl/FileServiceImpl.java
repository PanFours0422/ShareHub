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
    public List<File> getAllFiles() {
        return fileMapper.selectAll();
    }

    @Override
    public File getFileById(Long id) {
        return fileMapper.selectById(id);
    }

    @Override
    public List<File> getFilesByUserId(Long userId) {
        return fileMapper.selectByUserId(userId);
    }

    @Override
    @Transactional
    public boolean addFile(File file) {
        return fileMapper.insert(file) > 0;
    }

    @Override
    @Transactional
    public boolean updateFile(File file) {
        return fileMapper.update(file) > 0;
    }

    @Override
    @Transactional
    public boolean deleteFile(Long id) {
        return fileMapper.delete(id) > 0;
    }
}