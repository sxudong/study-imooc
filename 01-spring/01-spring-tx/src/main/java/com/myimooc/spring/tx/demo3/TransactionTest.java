package com.myimooc.spring.tx.demo3;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

/**
 * Spring的声明式事务管理的方式二：基于 AspectJ 的 XML 方式
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext3.xml")
public class TransactionTest {

    @Resource(name = "accountService")
    private AccountService accountService;

    @Test
    public void demo1() {
        //进行转账操作
        accountService.transfer("aaa", "bbb", 200d);
    }
}
