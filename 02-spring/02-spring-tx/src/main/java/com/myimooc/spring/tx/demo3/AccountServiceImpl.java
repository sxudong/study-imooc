package com.myimooc.spring.tx.demo3;

/**
 * 转账服务实现 -- Spring的声明式事务管理的方式二：基于 AspectJ 的 XML 方式
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
    public void transfer(String out, String in, Double money) {
        accountDao.outMoney(out, money);
        int i = 1/0; //aaa用户出账 -200，因异常事务回滚，aaa的账户金额没有损失
        accountDao.inMoney(in, money);
    }
}
