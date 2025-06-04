package com.sharehub.mapper;

import com.sharehub.entity.File;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface FileMapper {
    /**
     * 插入文件记录
     * @param file 文件信息
     * @return 影响行数
     */
    int insert(File file);

    /**
     * 根据ID查询文件
     * @param id 文件ID
     * @return 文件信息
     */
    File selectById(Long id);

    /**
     * 根据用户ID查询文件列表
     * @param userId 用户ID
     * @return 文件列表
     */
    List<File> selectByUserId(Long userId);

    /**
     * 分页查询文件列表
     * @param userId 用户ID
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 文件列表
     */
    List<File> selectPage(@Param("userId") Long userId,
                         @Param("offset") int offset,
                         @Param("limit") int limit);

    /**
     * 统计用户文件总数
     * @param userId 用户ID
     * @return 文件总数
     */
    int countByUserId(Long userId);

    /**
     * 更新文件状态
     * @param id 文件ID
     * @param status 状态
     * @return 影响行数
     */
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    /**
     * 删除文件记录
     * @param id 文件ID
     * @return 影响行数
     */
    int deleteById(Long id);
} 