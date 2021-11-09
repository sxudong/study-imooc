package com.SpringSourceAnalysis.ch10.transactional;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 《Spring源码深度解析》第10章 事务
 *  P254
 */
public class TransactionalTests {
    public static void main(String[] args) throws Exception {
        ApplicationContext act = new ClassPathXmlApplicationContext("test/tx/applicationContext-tx.xml");
        UserService userService = (UserService) act.getBean("userService");
        User user = new User();
        user.setName("张三ccc");
        user.setAge(20);
        user.setSex("男");

        // 保存一条数据
        userService.save(user);
    }
}
