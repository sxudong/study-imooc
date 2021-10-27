package com.SpringSource.ch05.beanfactoryaware;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 《Spring源码深度解析》P125 激活Aware方法 FactoryBean的使用 P83
 */
public class Test {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");
        BeanFactoryAwareDemo test = (BeanFactoryAwareDemo) ctx.getBean("test");
        test.testAware();
    }
}
/* Output:
hello
*///~
