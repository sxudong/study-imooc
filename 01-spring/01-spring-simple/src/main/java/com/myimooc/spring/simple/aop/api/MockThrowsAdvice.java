package com.myimooc.spring.simple.aop.api;

import org.springframework.aop.ThrowsAdvice;

import java.lang.reflect.Method;

/**
 * 异常拦截 (自定义抛异常后通知)
 *
 * 视频：6-1 Spring AOP API的Pointcut、advice概念及应用
 * 单元测试类：TestAOPAPI
 */
//Spring 1.2 用实现接口的方式实现通知，并在xml中配置bean，现在已经不再用，使用注解方式。
public class MockThrowsAdvice implements ThrowsAdvice {

    public void afterThrowing(Exception ex) {
        System.out.println("MockThrowsAdvice afterThrowing 1");
    }

    public void afterThrowing(Method method, Object[] args, Object target, Exception ex) {
        System.out.println("MockThrowsAdvice afterThrowing 2 : " + method.getName() + " # " + target.getClass().getName());
    }

}
