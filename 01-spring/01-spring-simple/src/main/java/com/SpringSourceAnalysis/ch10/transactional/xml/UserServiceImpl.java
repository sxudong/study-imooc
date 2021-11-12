package com.SpringSourceAnalysis.ch10.transactional.xml;

import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.sql.Types;

public class UserServiceImpl implements UserService{

    private JdbcTemplate jdbcTemplate;

    // 设置数据源
    public void setDataSource(DataSource dataSource){
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public void save(User user) throws Exception {
        jdbcTemplate.update("insert into user(name, age, sex) value(?, ?, ?)",
                new Object[]{ user.getName(), user.getAge(), user.getSex()},
                new int[]{Types.VARCHAR, Types.INTEGER, Types.VARCHAR});

        // 事务测试，加上这句代码则数据不会保存到数据库中
        // 注意：默认情况下 Spring 中的事务处理只对 RuntimeException 方法进行回滚，
        // 所以如果此处理将 RuntimeException 替换成普通的 Exception 不会产生回滚效果。
        throw new RuntimeException("UserServiceImpl 事务异常！");
    }
}
