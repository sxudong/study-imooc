package com.SpringSourceAnalysis.ch10.transactional.annotation;

import com.SpringSourceAnalysis.ch08.jdbc.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;


@Repository
public class UserDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void insert(User user) {
        jdbcTemplate.update ("insert into user (name, age, sex) values(?,?,?)",
                new Object[]{ user.getName(), user.getAge(), user.getSex()},
                new int[] { java.sql.Types. VARCHAR,java.sql.Types.INTEGER,java.sql. Types. VARCHAR });
    }
}
