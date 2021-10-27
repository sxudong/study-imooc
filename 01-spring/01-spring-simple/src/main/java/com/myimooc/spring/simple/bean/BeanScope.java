package com.myimooc.spring.simple.bean;

/**
 * Bean作用域
 * 视频：3-1 Spring Bean装配之Bean的配置项及作用域
 * 在 BeanScopeTest 中单元测试
 */
public class BeanScope {

    public void say() {
        System.out.println("BeanScope say : " + this.hashCode());
    }

}
