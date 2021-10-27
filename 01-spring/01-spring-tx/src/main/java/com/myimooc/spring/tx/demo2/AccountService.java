package com.myimooc.spring.tx.demo2;

/**
 * 账户服务 -- 声明式事务管理方式一
 */
public interface AccountService {

    /**
     * 进行转账
     *
     * @param out   出账账户
     * @param in    入账账户
     * @param money 转账金额
     */
    void transfer(String out, String in, Double money);
}
