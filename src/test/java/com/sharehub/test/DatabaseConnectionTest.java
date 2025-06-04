package com.sharehub.test;

import org.junit.jupiter.api.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DatabaseConnectionTest {

    @Test
    public void testDatabaseConnection() {
        try {
            // 加载Spring配置文件
            ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
            
            // 获取数据源
            DataSource dataSource = context.getBean("dataSource", DataSource.class);
            
            // 测试连接
            try (Connection conn = dataSource.getConnection()) {
                System.out.println("数据库连接成功！");
                System.out.println("数据库URL: " + conn.getMetaData().getURL());
                System.out.println("数据库用户名: " + conn.getMetaData().getUserName());
                System.out.println("数据库产品名称: " + conn.getMetaData().getDatabaseProductName());
                System.out.println("数据库产品版本: " + conn.getMetaData().getDatabaseProductVersion());
            }
            
            // 测试JdbcTemplate
            JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
            Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM user", Integer.class);
            System.out.println("用户表记录数: " + count);
            
        } catch (SQLException e) {
            System.err.println("数据库连接失败！");
            e.printStackTrace();
        }
    }

    @Test
    public void testUserTable() {
        try {
            // 加载Spring配置文件
            ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
            
            // 获取数据源
            DataSource dataSource = context.getBean("dataSource", DataSource.class);
            JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
            
            // 测试插入用户
            String sql = "INSERT INTO user (username, password, email, status) VALUES (?, ?, ?, ?)";
            int result = jdbcTemplate.update(sql, "testuser", "password123", "test@example.com", 1);
            System.out.println("插入用户结果: " + (result > 0 ? "成功" : "失败"));
            
            // 测试查询用户
            String querySql = "SELECT COUNT(*) FROM user WHERE username = ?";
            Integer count = jdbcTemplate.queryForObject(querySql, Integer.class, "testuser");
            System.out.println("查询到用户数: " + count);
            
        } catch (Exception e) {
            System.err.println("测试用户表失败！");
            e.printStackTrace();
        }
    }
} 