package com.myimooc.spring.tx.demo3;

/**
 * 转账服务 -- Spring的声明式事务管理的方式二：基于 AspectJ 的 XML 方式
 *
 * @author zc 2017-02-16
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
