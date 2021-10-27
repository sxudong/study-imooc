package com.SpringSource.ch02.basic;

import org.junit.Test;
import org.junit.jupiter.api.Assertions;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 2.1 容器的基本用法
 * 《Spring源码深度解析》P10
 */
public class BeanFactoryTest {

    @Test
    public void testSimpleLoad(){
        BeanFactory beanFactory = new ClassPathXmlApplicationContext("test/beanFactory.xml");
        MyTestBean bean = (MyTestBean) beanFactory.getBean("myTestBean");
        Assertions.assertEquals("testStr",bean.getTestStr());
    }
}
