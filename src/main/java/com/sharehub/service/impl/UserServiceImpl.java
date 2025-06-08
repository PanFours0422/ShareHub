package com.sharehub.service.impl;

import com.sharehub.entity.User;
import com.sharehub.mapper.UserMapper;
import com.sharehub.service.UserService;
import com.sharehub.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public boolean register(User user) {
        // 检查用户名是否存在
        if (isUsernameExists(user.getUsername())) {
            System.out.println("注册失败：用户名已存在 - " + user.getUsername());
            return false;
        }
        // 检查邮箱是否存在
        if (isEmailExists(user.getEmail())) {
            System.out.println("注册失败：邮箱已存在 - " + user.getEmail());
            return false;
        }
        // 密码加密
        String originalPassword = user.getPassword();
        String encryptedPassword = PasswordUtil.encrypt(originalPassword);
        user.setPassword(encryptedPassword);
        System.out.println("注册 - 原始密码: " + originalPassword);
        System.out.println("注册 - 加密后密码: " + encryptedPassword);
        
        // 设置状态为正常
        user.setStatus(1);
        // 插入用户
        boolean result = userMapper.insert(user) > 0;
        System.out.println("注册结果: " + (result ? "成功" : "失败"));
        return result;
    }

    @Override
    public User login(String username, String password) {
        System.out.println("开始登录验证 - 用户名: " + username);
        
        // 根据用户名查询用户
        User user = userMapper.selectByUsername(username);
        if (user == null) {
            System.out.println("登录失败：用户不存在 - " + username);
            return null;
        }
        
        System.out.println("登录 - 输入的原始密码: " + password);
        System.out.println("登录 - 数据库中存储的密码: " + user.getPassword());
        
        // 验证密码
        String encryptedInput = PasswordUtil.encrypt(password);
        System.out.println("登录 - 输入密码加密后: " + encryptedInput);
        
        if (!PasswordUtil.verify(password, user.getPassword())) {
            System.out.println("登录失败：密码不匹配");
            System.out.println("登录 - 加密后的输入密码: " + encryptedInput);
            System.out.println("登录 - 数据库中的密码: " + user.getPassword());
            return null;
        }
        
        System.out.println("登录成功: " + username);
        return user;
    }

    @Override
    public boolean isUsernameExists(String username) {
        return userMapper.selectByUsername(username) != null;
    }

    @Override
    public boolean isEmailExists(String email) {
        return userMapper.selectByEmail(email) != null;
    }

    @Override
    public boolean isPhoneExists(String phone) {
        return userMapper.selectByPhone(phone) != null;
    }
} 