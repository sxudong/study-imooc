package com.SpringSource.ch07.dynamicAOP;

import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 《Spring源码尝试解析》7.1 动态AOP使用示例
 */
public class TestDynamicAop {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext bf = new ClassPathXmlApplicationContext("aspectTest.xml");
        TestBean bean = (TestBean) bf.getBean("test");
        bean.test();
    }
}
/* Output:
before1
beforeTest
test
before2
afterTest
 */