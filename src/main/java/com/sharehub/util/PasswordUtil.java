package com.sharehub.util;

import org.springframework.util.DigestUtils;

public class PasswordUtil {
    
    /**
     * 加密密码
     * @param password 原始密码
     * @return 加密后的密码
     */
    public static String encrypt(String password) {
        return DigestUtils.md5DigestAsHex(password.getBytes());
    }
    
    /**
     * 验证密码
     * @param inputPassword 输入的密码
     * @param encryptedPassword 加密后的密码
     * @return 是否匹配
     */
    public static boolean verify(String inputPassword, String encryptedPassword) {
        String encryptedInput = encrypt(inputPassword);
        return encryptedInput.equals(encryptedPassword);
    }
} 