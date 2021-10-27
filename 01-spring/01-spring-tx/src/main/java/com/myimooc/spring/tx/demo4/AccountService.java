package com.myimooc.spring.tx.demo4;

/**
 * 转账服务 -- Spring的声明式事务管理的方式二：基于注解的方式
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
