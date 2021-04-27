package com.myimooc.spring.tx.demo1;

/**
 * 账户服务
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
