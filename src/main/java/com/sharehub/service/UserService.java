package com.sharehub.service;

import com.sharehub.entity.User;

public interface UserService {
    /**
     * 用户注册
     * @param user 用户信息
     * @return 是否注册成功
     */
    boolean register(User user);

    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @return 登录成功的用户信息，失败返回null
     */
    User login(String username, String password);

    /**
     * 检查用户名是否存在
     * @param username 用户名
     * @return 是否存在
     */
    boolean isUsernameExists(String username);

    /**
     * 检查邮箱是否存在
     * @param email 邮箱
     * @return 是否存在
     */
    boolean isEmailExists(String email);
} 