package com.myimooc.spring.tx.demo;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

/**
 * 账户服务测试
 *
 * 配置文件：applicationContext.xml jdbc.properties
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class TransactionTest {

    @Resource(name = "accountService")
    private AccountService accountService;

    @Test
    public void demo1() {
        //进行转账操作
        accountService.transfer("aaa", "bbb", 200d);
    }
}
