package com.SpringSource.ch07.aop.dynamicProxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * 使用自定义的InvocationHandler,对用于接口提供的方法进行增加。
 * 《Spring源码尝试解析》P191
 */
public class MyInvocationHandler implements InvocationHandler {
    //目标对象
    private Object target;

    /**
     * 构造方法
     * @param target 目标对象
     */
    public MyInvocationHandler(Object target) {
        super();
        this.target = target;
    }

    /**
     * 执行目标对象的方法
     */
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("---------------before---------------");
        Object result = method.invoke(target, args);
        System.out.println("---------------after---------------");
        return result;
    }

    /**
     * 获取目标对象的代理对象
     * @return 代理对象
     */
    public Object getProxy(){
        return Proxy.newProxyInstance(Thread.currentThread().getContextClassLoader(),
                target.getClass().getInterfaces(), this);
    }
}
