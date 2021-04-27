package com.myimooc.spring.tx.demo3;

/**
 * 账户DAO -- Spring的声明式事务管理的方式二：基于 AspectJ 的 XML 方式
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
