package com.myimooc.spring.simple.lifecycle;

import org.springframework.beans.factory.InitializingBean;

/**
 * Bean初始化时执行
 *
 * 视频：3-2 Spring Bean装配之Bean的生命周期
 * 在 BeanLifecycleTest 中单元测试
 */
public class ExampleInitializingBean implements InitializingBean {

    @Override
    public void afterPropertiesSet() {
        System.out.println(this.getClass().getName() + "：initializing");
    }

}
