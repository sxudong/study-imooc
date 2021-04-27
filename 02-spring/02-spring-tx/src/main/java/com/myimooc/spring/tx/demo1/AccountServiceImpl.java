package com.myimooc.spring.tx.demo1;

import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallbackWithoutResult;
import org.springframework.transaction.support.TransactionTemplate;

/**
 * 账户服务实现 -- 编程式事务管理
 */
public class AccountServiceImpl implements AccountService {

    // 注入转账的DAO的类
    private AccountDao accountDao;
    // 注入事务管理的模板
    private TransactionTemplate transactionTemplate;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    public void setTransactionTemplate(TransactionTemplate transactionTemplate) {
        this.transactionTemplate = transactionTemplate;
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
        //编程式事务管理 —— 这两个事务会被绑定到一个事务中
        transactionTemplate.execute(new TransactionCallbackWithoutResult() {
            @Override
            protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
                //需要进行事务管理，要么一起成功，要么一起失败
                accountDao.outMoney(out, money); //出账 -200
                int i = 1/0; //aaa用户出账 -200，因异常事务回滚，aaa的账户金额没有损失
                accountDao.inMoney(in, money); //入账 +200
            }
        });
    }
}
