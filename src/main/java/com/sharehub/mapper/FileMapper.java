package com.sharehub.mapper;

import com.sharehub.entity.File;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface FileMapper {
    /**
     * 获取所有文件
     */
    List<File> selectAll();
    
    /**
     * 根据ID查询文件
     */
    File selectById(Long id);
    
    /**
     * 根据用户ID查询文件
     */
    List<File> selectByUserId(Long userId);
    
    /**
     * 添加文件
     */
    int insert(File file);
    
    /**
     * 更新文件信息
     */
    int update(File file);
    
    /**
     * 删除文件
     */
    int delete(Long id);

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
} 