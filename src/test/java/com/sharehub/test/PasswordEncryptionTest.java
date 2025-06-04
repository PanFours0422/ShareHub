package com.sharehub.test;

import org.junit.jupiter.api.Test;
import org.springframework.util.DigestUtils;

public class PasswordEncryptionTest {

    @Test
    public void testPasswordEncryption() {
        String password = "password123";
        String encrypted = DigestUtils.md5DigestAsHex(password.getBytes());
        System.out.println("原始密码: " + password);
        System.out.println("加密后: " + encrypted);
        
        // 验证加密结果是否一致
        String encrypted2 = DigestUtils.md5DigestAsHex(password.getBytes());
        System.out.println("再次加密: " + encrypted2);
        System.out.println("两次加密结果是否一致: " + encrypted.equals(encrypted2));
    }

    @Test
    public void testPasswordVerification() {
        String password = "password123";
        String encrypted = DigestUtils.md5DigestAsHex(password.getBytes());
        
        // 模拟登录验证
        String inputPassword = "password123";
        String encryptedInput = DigestUtils.md5DigestAsHex(inputPassword.getBytes());
        
        System.out.println("数据库中的密码: " + encrypted);
        System.out.println("输入的密码加密后: " + encryptedInput);
        System.out.println("密码验证结果: " + encrypted.equals(encryptedInput));
    }
} 