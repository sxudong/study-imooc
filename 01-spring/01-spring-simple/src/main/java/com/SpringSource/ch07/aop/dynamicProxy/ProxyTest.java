package com.SpringSource.ch07.aop.dynamicProxy;


/**
 * 《Spring源码尝试解析》7.3.3 创建代理 —— JDK代理使用示例
 *  P191
 */
public class ProxyTest {

    public static void main(String[] args) {
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