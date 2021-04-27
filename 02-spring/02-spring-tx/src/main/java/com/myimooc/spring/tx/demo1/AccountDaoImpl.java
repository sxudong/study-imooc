package com.myimooc.spring.tx.demo1;

import org.springframework.jdbc.core.support.JdbcDaoSupport;

/**
 * 账户 DAO 实现
 * 编写 DAO 注入，注入 JdbcTemplate
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
