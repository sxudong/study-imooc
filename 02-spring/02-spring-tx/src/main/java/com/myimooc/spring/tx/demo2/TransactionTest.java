package com.myimooc.spring.tx.demo2;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

/**
 * Spring的声明式事务管理的方式一的测试类
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext2.xml")
public class TransactionTest {

    // 注入代理类：因为代理类进行增加的操作
    //@Resource(name = "accountServiceProxy")
    @Autowired
    @Qualifier("accountServiceProxy")
    private AccountService accountService;

    @Test
    public void demo1() {
        //进行转账操作
        accountService.transfer("aaa", "bbb", 200d);
    }
}
