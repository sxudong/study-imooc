package com.myimooc.spring.tx.demo2;

/**
 * 账户DAO -- 声明式事务管理方式一
 */
public interface AccountDao {

    /**
     * 功能：从账号中转出金额
     *
     * @param out   转出账号
     * @param money 转账金额
     */
    void outMoney(String out, Double money);

    /**
     * 功能：从账号中转入金额
     *
     * @param in    转入账号
     * @param money 转账金额
     */
    void inMoney(String in, Double money);
}
