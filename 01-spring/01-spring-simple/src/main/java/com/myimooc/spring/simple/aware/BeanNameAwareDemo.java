package com.myimooc.spring.simple.aware;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * BeanNameAware 扩展接口；获取 Bean 名称
 *
 * 视频：3-3 Spring Bean装配之Aware接口（增强接口）
 * 在 AwareTest 中单元测试
 *
 * ApplicationContextAware：当 ApplicationContext 创建一个实现
 * org.springframework.context.ApplicationContextAware 接口的类时，
 * 该类提供了对该 ApplicationContext 的引用。
 *
 * BeanNameAware：当实现 org.springframework.beans.factory.BeanNameAware 接口的
 * ApplicationContext 时，该类提供了对其关联对象定义中定义的名称的引用。
 */
public class BeanNameAwareDemo implements BeanNameAware, ApplicationContextAware {

    private String beanName;

    @Override
    public void setBeanName(String name) {
        this.beanName = name;
        System.out.println("BeanNameAware : " + name);
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        System.out.println("setApplicationContext : " + applicationContext.getBean(this.beanName).hashCode());
    }

}
