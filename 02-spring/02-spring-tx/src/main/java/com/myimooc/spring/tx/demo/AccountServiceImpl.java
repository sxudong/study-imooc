package com.myimooc.spring.tx.demo;

/**
 * 账户服务实现
 *
 * @author zc 2017-02-16
 */
public class AccountServiceImpl implements AccountService {

    // 注入转账的DAO的类
    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    @Override
    public void transfer(final String out, final String in, final Double money) {
        accountDao.outMoney(out, money);
        //int i = 1/0;
        accountDao.inMoney(in, money);
    }
}