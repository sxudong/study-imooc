package com.myimooc.spring.simple.exposeProxy;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

/**
 * 添加一个 Aspect 类，在其中增加一个前置通知
 */
@Component
@Aspect
public class DKAspect1 {
    @Pointcut("this(com.myimooc.spring.simple.exposeProxy.MessageService)")
    public void pointcut1(){}

    @Before("pointcut1()")
    public void before(JoinPoint joinPoint){
        System.out.println("前置通知,被增强的方法是:"+joinPoint.toString());
    }
}
