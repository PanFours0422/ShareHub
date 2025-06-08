package com.sharehub.mapper;

import com.sharehub.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface UserMapper {
    /**
     * 插入用户
     * @param user 用户信息
     * @return 影响行数
     */
    int insert(User user);

    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户信息
     */
    User selectByUsername(String username);

    /**
     * 根据邮箱查询用户
     * @param email 邮箱
     * @return 用户信息
     */
    User selectByEmail(String email);

    /**
     * 根据电话查询用户
     * @param phone 电话
     * @return 用户信息
     */
    User selectByPhone(String phone);

    /**
     * 更新用户信息
     */
    int update(User user);

    /**
     * 删除用户
     */
    int delete(Long id);

    /**
     * 获取所有用户
     */
    List<User> selectAll();

    /**
     * 根据ID查询用户
     */
    User selectById(Long id);
} 