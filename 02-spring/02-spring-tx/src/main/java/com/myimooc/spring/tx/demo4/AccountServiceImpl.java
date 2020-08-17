package com.myimooc.spring.tx.demo4;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 转账服务实现
 *
 * @Transactional注解中的属性
 *      propagation    :事务的传播行为
 *      isolation      :事务的隔离级别
 *      readOnly       :只读
 *      rollbackFor    :发生哪些异常回滚
 *      noRollbackFor  :发生哪些异常不回滚
 */
// @Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = false, rollbackFor = Exception.class)
@Transactional(rollbackFor = Exception.class)
public class AccountServiceImpl implements AccountService {

    // 注入转账的DAO的类
    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    // 转账的业务操作
    @Override
    public void transfer(String out, String in, Double money) {
        accountDao.outMoney(out, money);
        int i = 1/0;
        accountDao.inMoney(in, money);
    }
}
