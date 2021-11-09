package com.SpringSourceAnalysis.ch03.replacemethod;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 第3章 默认标签的解析
 *   3.1 bean标签的解析及注册
 *   3.1.1 解析BeanDefinition
 *   ........ 5．解析子元素 replaced-method
 *
 * 《Spring源码深度解析》P46
 */
public class Main {

    public static void main(String[] args) {
        ApplicationContext applicationContext
                = new ClassPathXmlApplicationContext("classpath:test/replacemethod/replaceMethodTest.xml");
        TestChangeMethod test = (TestChangeMethod) applicationContext.getBean("testChangeMethod");
        test.changeMe();
    }
}
/* Output:
我替换了原有的方法!
*///~
