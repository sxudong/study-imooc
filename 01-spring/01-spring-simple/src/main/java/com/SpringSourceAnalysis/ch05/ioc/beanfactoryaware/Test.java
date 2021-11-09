package com.SpringSourceAnalysis.ch05.ioc.beanfactoryaware;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 《Spring源码深度解析》P125 激活Aware方法 FactoryBean的使用 P83
 */
public class Test {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("test/ioc/applicationContext.xml");
        BeanFactoryAwareDemo test = (BeanFactoryAwareDemo) ctx.getBean("test");
        test.testAware();
    }
}
/* Output:
hello
*///~
