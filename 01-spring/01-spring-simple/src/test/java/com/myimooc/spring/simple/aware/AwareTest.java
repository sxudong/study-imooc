package com.myimooc.spring.simple.aware;

import com.myimooc.spring.simple.base.UnitTestBase;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

/**
 * Aware接口测试
 *
 * 视频：3-3 Spring Bean装配之Aware接口（增强接口）
 */
@RunWith(BlockJUnit4ClassRunner.class)
public class AwareTest extends UnitTestBase {

    public AwareTest() {
        super("spring-aware.xml");
    }

    @Test
    public void testMockApplicationContext() {
        System.out.println("testMockApplicationContext : " + super.getBean("mockApplicationContext", ApplicationContextAwareDemo.class).hashCode());
    } /* Output:
        ApplicationContextAware : 1521083627     //在 MockApplicationContext.java 中打印的
        BeanNameAware : mockBeanName             //在 MockBeanName 中打印的
        setApplicationContext : 328827614       //在 MockBeanName 中打印的
        testMockApplicationContext : 1521083627 //在测试类 AwareTest.java 中打印的
     *///~


    @Test
    public void textMockBeanName() {
        System.out.println("textMockBeanName : " + super.getBean("mockBeanName", BeanNameAwareDemo.class).hashCode());
    } /* Output:
        ApplicationContextAware : 1521083627    //在 MockApplicationContext.java 中打印的
        BeanNameAware : mockBeanName            //在 MockBeanName 中打印的
        setApplicationContext : 328827614      //在 MockBeanName 中打印的
        textMockBeanName : 328827614           //在测试类 AwareTest.java 中打印的
    *///~

}
