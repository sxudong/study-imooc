package com.SpringSource.ch08.jdbc.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.SpringSource.ch08.jdbc.pojo.User;
import org.springframework.jdbc.core.RowMapper;

/**
 * 《Spring源码深度解析》P215
 */
public class UserRowMapper implements RowMapper {
    /**
     * 用户实体对象与行记录做映射关系
     */
    @Override
    public Object mapRow(ResultSet set, int rowNum) throws SQLException {
        User person = new User(set.getInt("id"),
                set.getString("name"),
                set.getInt("age"),
                set.getString( "sex"));
        return person ;
    }
}
