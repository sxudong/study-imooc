package com.SpringSourceAnalysis.ch03.lookupMethod;

import com.SpringSourceAnalysis.ch03.lookupMethod.app.BeanRegisterTest;
import com.SpringSourceAnalysis.ch03.lookupMethod.app.GetBeanTest;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 4.解析子元素 lookup-method
 * 《Spring源码深度解析》P44
 */
public class Main {

    public static void main(String[] args) {
        ApplicationContext applicationContext
                = new ClassPathXmlApplicationContext("test/lookup/lookupTest.xml");
        GetBeanTest test = (GetBeanTest) applicationContext.getBean("getBeanTest");
        test.showMe();
        BeanRegisterTest brt = (BeanRegisterTest) applicationContext.getBean("beanregistertest");
    }
}
/* Output:
com.myimooc.spring.simple.lookupMethod.app
*///~
