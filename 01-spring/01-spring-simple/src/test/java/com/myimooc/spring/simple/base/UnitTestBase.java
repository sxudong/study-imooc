package com.myimooc.spring.simple.base;

import org.junit.After;
import org.junit.Before;
import org.springframework.beans.BeansException;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.util.StringUtils;

/**
 * 支持单元测试的基类
 */
public class UnitTestBase {

    private ClassPathXmlApplicationContext context;

    private String springXmlPath;

    public UnitTestBase() {
    }

    public UnitTestBase(String springXmlPath) {
        this.springXmlPath = springXmlPath;
    }

    @Before
    public void before() {
        if (StringUtils.isEmpty(springXmlPath)) {
            springXmlPath = "classpath*:" + springXmlPath;
            //springXmlPath = "classpath*:spring-*.xml";
        }
        try {
            context = new ClassPathXmlApplicationContext(springXmlPath.split("[,\\s]+"));
            context.start();
        } catch (BeansException e) {
            e.printStackTrace();
        }
    }

    @After
    public void after() {
        context.close();
    }

    @SuppressWarnings("unchecked")
    protected <T> T getBean(String beanId, Class<T> typeClass) {
        try {
            return (T) context.getBean(beanId, typeClass);
        } catch (BeansException e) {
            throw new RuntimeException("获取Bean异常：", e);
        }
    }

    @SuppressWarnings("unchecked")
    protected <T> T getBean(Class<T> clazz) {
        try {
            return (T) context.getBean(clazz);
        } catch (BeansException e) {
            throw new RuntimeException("获取Bean异常：", e);
        }
    }

    // 原代码
    @SuppressWarnings("unchecked")
    protected <T extends Object> T getBean(String beanId) {
        try {
            return (T) context.getBean(beanId);
        } catch (BeansException e) {
            e.printStackTrace();
            return null;
        }
    }
//
//    protected <T extends Object> T getBean(Class<T> clazz) {
//        try {
//            return context.getBean(clazz);
//        } catch (BeansException e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
}
