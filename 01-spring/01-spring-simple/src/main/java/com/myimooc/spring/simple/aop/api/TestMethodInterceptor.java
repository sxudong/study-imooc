package com.myimooc.spring.simple.aop.api;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.springframework.aop.framework.ProxyFactory;

/**
 * Spring方法拦截器 —— MethodInterceptor
 *
 * 实现MethodInterceptor 接口，在调用目标对象的方法时，就可以实现在调用方法之前、调用方法过程中、调用方法之后对其进行控制。
 *
 * MethodInterceptor 接口可以实现MethodBeforeAdvice接口、AfterReturningAdvice接口、ThrowsAdvice接口这三个接口能
 * 够所能够实现的功能，但是应该谨慎使用MethodInterceptor 接口，很可能因为一时的疏忽忘记最重要的MethodInvocation而造成对
 * 目标对象方法调用失效，或者不能达到预期的设想。
 *
 * 原文链接：https://blog.csdn.net/u012834750/article/details/71773887
 */
//Spring 1.2 用实现接口的方式实现通知，并在xml中配置bean，现在已经不再用，使用注解方式。
public class TestMethodInterceptor {

    public static void main(String[] args) {
        //底层 AbstractAutoProxyCreator 类中就是这样创建的
        ProxyFactory proxyFactory = new ProxyFactory();
        proxyFactory.setTarget(new TestMethodInterceptor());   //设置被代理对象
        proxyFactory.addAdvice(new adviseMethodInterceptor()); //保存到proxyFactory

        //创建AOP代理对象，并返回最终的代理对象
        Object proxy = proxyFactory.getProxy();
        TestMethodInterceptor methodInterceptor = (TestMethodInterceptor) proxy;

        methodInterceptor.doSomeThing("通过代理工厂设置代理对象，拦截代理方法");
    }

    public static class adviseMethodInterceptor implements MethodInterceptor {
        @Override
        public Object invoke(MethodInvocation methodInvocation) throws Throwable {

            Object result = null;
            try {
                System.out.println("方法执行之前：" + methodInvocation.getMethod().toString());

                result = methodInvocation.proceed();

                System.out.println("方法执行之后：" + methodInvocation.getMethod().toString());
                System.out.println("方法正常运行结果：" + result);

                return result;
            } catch (Exception e) {
                System.out.println("方法出现异常:" + e.toString());
                System.out.println("方法运行Exception结果：" + result);
                return result;
            }

        }
    }

    public String doSomeThing(String someThing) {
        //System.out.println("执行被拦截的方法：" + someThing);
        //int i=5/0;
        return "执行被拦截的方法：" + someThing;
    }
}
/* 正常运行结果：
方法执行之前：public java.lang.String com.myimooc.spring.simple.aop.api.TestMethodInterceptor.doSomeThing(java.lang.String)
方法执行之后：public java.lang.String com.myimooc.spring.simple.aop.api.TestMethodInterceptor.doSomeThing(java.lang.String)
方法正常运行结果：执行被拦截的方法：通过代理工厂设置代理对象，拦截代理方法
*///~

/* 异常运行结果：
方法执行之前：public java.lang.String com.myimooc.spring.simple.aop.api.TestMethodInterceptor.doSomeThing(java.lang.String)
方法出现异常:java.lang.ArithmeticException: / by zero
方法运行Exception结果：null
*///~