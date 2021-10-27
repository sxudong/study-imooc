package com.myimooc.spring.simple.aop.api;

import org.springframework.aop.MethodBeforeAdvice;

import java.lang.reflect.Method;

/**
 * 方法执行前拦截 (自定义前置通知)
 *
 * 视频：6-1 Spring AOP API的Pointcut、advice概念及应用
 * 单元测试类：TestAOPAPI
 */
//Spring 1.2 用实现接口的方式实现通知，并在xml中配置bean，现在已经不再用，使用注解方式。
public class MockBeforeAdvice implements MethodBeforeAdvice {

    @Override
    public void before(Method method, Object[] args, Object target) {
        System.out.println("MockBeforeAdvice : " + method.getName()
                + "   " + target.getClass().getName());
    }

}
