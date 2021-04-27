package com.myimooc.spring.tx.demo2;

/**
 * 账户服务实现 -- 声明式事务管理方式一
 */
public class AccountServiceImpl implements AccountService {

    // 注入转账的DAO的类
    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    /**
     * 进行转账 -- 声明式事务管理方式一
     *
     * @param out   出账账户
     * @param in    入账账户
     * @param money 转账金额
     */
    @Override
    public void transfer(String out, String in, Double money) {
        // 在applicationContext1.xml中声明了事务
        accountDao.outMoney(out, money); //出账 -200
        int i = 1/0; //aaa用户出账 -200，因异常事务回滚，aaa的账户金额没有损失
        accountDao.inMoney(in, money); //入账 +200
    }
}
