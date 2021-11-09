package com.SpringSourceAnalysis.ch06.applicationContext.test;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.core.Ordered;

/**
 * 继承 BeanPostProcessor接口 并重写其方法
 *
 * 单元测试类：BeanPostProcessorTest
 */
public class MyBeanPostProcessorTwo implements BeanPostProcessor, Ordered {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("BeanPostProcessor第" + getOrder() + "次被调动");
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        return bean;
    }

    @Override
    public int getOrder() {
        return 2;
    }
}
