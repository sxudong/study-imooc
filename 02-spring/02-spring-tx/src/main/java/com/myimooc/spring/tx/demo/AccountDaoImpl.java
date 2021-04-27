package com.myimooc.spring.tx.demo;

import org.springframework.jdbc.core.support.JdbcDaoSupport;

/**
 * 账户DAO实现
 * 编写DAO注入 注入JdbcTemplate
 */
public class AccountDaoImpl extends JdbcDaoSupport implements AccountDao {

    /**
     * 出账
     *
     * @param out   转出账户
     * @param money 金额
     */
    @Override
    public void outMoney(String out, Double money) {
        String sql = "update account set money = money-? where name = ?";
        this.getJdbcTemplate().update(sql, money, out);
    }

    /**
     * 入账
     *
     * @param in    转入账户
     * @param money 金额
     */
    @Override
    public void inMoney(String in, Double money) {
        String sql = "update account set money = money+? where name = ?";
        this.getJdbcTemplate().update(sql, money, in);
    }

}
