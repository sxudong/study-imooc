package com.myimooc.spring.simple.lifecycle;

import org.springframework.beans.factory.DisposableBean;

/**
 * Bean销毁时执行
 *
 * 视频：3-2 Spring Bean装配之Bean的生命周期
 * 在 BeanLifecycleTest 中单元测试
 */
public class ExampleDisposableBean implements DisposableBean {

    @Override
    public void destroy() {
        System.out.println(this.getClass().getName() + "：destroy");
    }

}
