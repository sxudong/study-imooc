package com.myimooc.spring.tx.demo;

/**
 * 账户服务实现
 */
public class AccountServiceImpl implements AccountService {

    // 注入转账的DAO的类
    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    /**
     * 进行转账
     *
     * @param out   出账账户
     * @param in    入账账户
     * @param money 转账金额
     */
    @Override
    public void transfer(final String out, final String in, final Double money) {
        //需要进行事务管理，要么一起成功，要么一起失败
        accountDao.outMoney(out, money); //出账 -200
        int i = 1/0; //aaa用户出账 -200，bbb用户因异常未收到钱
        accountDao.inMoney(in, money); //入账 +200
    }
}
