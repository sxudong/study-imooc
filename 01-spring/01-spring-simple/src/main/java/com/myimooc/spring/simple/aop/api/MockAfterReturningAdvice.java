package com.myimooc.spring.simple.aop.api;

import java.lang.reflect.Method;

import org.springframework.aop.AfterReturningAdvice;

/**
 * 正常返回拦截（自定义返回后通知）
 *
 * 视频：6-1 Spring AOP API的Pointcut、advice概念及应用
 * 单元测试类：TestAOPAPI
 */
//Spring 1.2 用实现接口的方式实现通知，并在xml中配置bean，现在已经不再用，使用注解方式。
public class MockAfterReturningAdvice implements AfterReturningAdvice { //定义一个advice(增强逻辑)

    @Override
    public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
        System.out.println("MockAfterReturningAdvice : " + method.getName() + " ## "
                + target.getClass().getName() + "   " + returnValue);
    }

}
