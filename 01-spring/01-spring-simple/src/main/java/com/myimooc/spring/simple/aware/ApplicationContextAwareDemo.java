package com.myimooc.spring.simple.aware;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * ApplicationContextAware 扩展接口；获取 ApplicationContext
 *
 * 视频：3-3 Spring Bean装配之Aware接口（增强接口）
 * 在 AwareTest 中单元测试
 *
 * 1、Spring 中提供了一些以 Aware 结尾的接口，实现了 Aware 接口的 bean 在被初始化之后，可以获取相应资源。
 * 2、通过 Aware 接口，可以对 Spring 相应资源进行操作(一定要慎重)。
 * 3、为对 Spring 进行简单的扩展提供了方便的入口。
 */
public class ApplicationContextAwareDemo implements ApplicationContextAware {

    //在 setApplicationContext()方法中 获取 applicationContext 中的 Bean
    @Override
    public void setApplicationContext(ApplicationContext applicationContext)
            throws BeansException {
        System.out.println("ApplicationContextAware : " + applicationContext.getBean("mockApplicationContext").hashCode());
    }
}
