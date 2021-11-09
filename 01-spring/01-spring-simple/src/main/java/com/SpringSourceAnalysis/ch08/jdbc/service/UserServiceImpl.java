package com.SpringSourceAnalysis.ch08.jdbc.service;

import com.SpringSourceAnalysis.ch08.jdbc.mapper.UserRowMapper;
import com.SpringSourceAnalysis.ch08.jdbc.pojo.User;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.util.List;

/**
 * 数据操作接口实现类
 * 《Spring源码深度解析》P215
 */
public class UserServiceImpl implements UserService{
    private JdbcTemplate jdbcTemplate;

    //设置数据源
    public void setDataSource(DataSource dataSource){
        this.jdbcTemplate = new JdbcTemplate(dataSource) ;
    }

    @Override
    public void save(User user) {
        jdbcTemplate.update ("insert into user (name, age, sex) values(?,?,?)",
                new Object[]{ user.getName(), user.getAge(), user.getSex()},
                new int[] { java.sql.Types. VARCHAR,java.sql.Types.INTEGER,java.sql. Types. VARCHAR });
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<User> getUsers() {
        List<User> list = jdbcTemplate.query("select * from user", new UserRowMapper());
        return list;
    }

    @Override
    public Long queryCount() {
        String sql = "select count(id) from user";
        Long total = jdbcTemplate.queryForObject(sql, Long.class);
        return total;
    }
}
