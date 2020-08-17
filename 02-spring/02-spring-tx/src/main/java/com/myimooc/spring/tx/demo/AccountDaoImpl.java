package com.myimooc.spring.tx.demo;

import org.springframework.jdbc.core.support.JdbcDaoSupport;

/**
 * 账户DAO实现
 * 编写DAO注入 注入JdbcTemplate
 * @author zc 2017-02-16
 */
public class AccountDaoImpl extends JdbcDaoSupport implements AccountDao {

    @Override
    public void outMoney(String out, Double money) {
        String sql = "update account set money = money-? where name = ?";
        this.getJdbcTemplate().update(sql, money, out);
    }

    @Override
    public void inMoney(String in, Double money) {
        String sql = "update account set money = money+? where name = ?";
        this.getJdbcTemplate().update(sql, money, in);
    }

}
