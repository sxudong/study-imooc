package com.myimooc.spring.simple.lifecycle;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;

/**
 * Bean生命周期
 *
 * 视频：3-2 Spring Bean装配之Bean的生命周期
 * 在 BeanLifecycleTest 中单元测试
 */
public class BeanLifeCycle implements InitializingBean, DisposableBean {

    public void defaultInit() {
        System.out.println("Bean defaultInit.");
    }

    public void defaultDestroy() {
        System.out.println("Bean defaultDestroy.");
    }

    @Override
    public void destroy() {
        System.out.println("Bean destroy.");
    }

    @Override
    public void afterPropertiesSet() {
        System.out.println("Bean afterPropertiesSet.");
    }

    public void start() {
        System.out.println("Bean start .");
    }

    public void stop() {
        System.out.println("Bean stop.");
    }

}
