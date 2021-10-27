package com.SpringSource.ch07.dynamicProxy;

import org.junit.Test;

/**
 * JDK代理使用示例
 * 《Spring源码尝试解析》P191
 */
public class ProxyTest {
    @Test
    public void testProxy() throws Throwable{
        //实例化目标对象
        UserServiceImpl userService = new UserServiceImpl();
        //实例化MyInvocationHandler
        MyInvocationHandler invocationHandler = new MyInvocationHandler(userService);
        //根据目标对象生成代理对象
        UserService proxy = (UserService) invocationHandler.getProxy();
        //调用代理对象的方法
        proxy.add();
    }
}
/* Output:
---------------before---------------
---------------add---------------
---------------after---------------
*///~