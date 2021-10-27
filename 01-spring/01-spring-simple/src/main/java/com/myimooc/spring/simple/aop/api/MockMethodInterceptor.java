package com.myimooc.spring.simple.aop.api;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

/**
 * Spring方法拦截器 MethodInterceptor 可以实现 自定义环绕通知
 *
 * 视频：6-1 Spring AOP API的Pointcut、advice概念及应用
 * 单元测试类：TestAOPAPI
 *
 * 实现 MethodInterceptor接口，在调用目标对象的方法时，就可以实现在调用方法之前、调用方法过程中、调用方法之后对其进行控制。
 *
 * MethodInterceptor 接口可以实现 MethodBeforeAdvice接口、AfterReturningAdvice接口、ThrowsAdvice接口 这三个接口
 * 能够所能够实现的功能，但是应该谨慎使用 MethodInterceptor接口，很可能因为一时的疏忽忘记最重要的 MethodInvocation 而造
 * 成对目标对象方法调用失效，或者不能达到预期的设想。
 */
//Spring 1.2 用实现接口的方式实现通知，并在xml中配置bean，现在已经不再用，使用注解方式。
public class MockMethodInterceptor implements MethodInterceptor {

    @Override
    public Object invoke(MethodInvocation invocation) throws Throwable {
        System.out.println("MockMethodInterceptor 1 : " + invocation.getMethod().getName()
                + "  " + invocation.getStaticPart().getClass().getName());
        //方法前
        Object obj = invocation.proceed();
        //方法后
        System.out.println("MockMethodInterceptor 2 : " + obj);
        return obj;
    }
}
