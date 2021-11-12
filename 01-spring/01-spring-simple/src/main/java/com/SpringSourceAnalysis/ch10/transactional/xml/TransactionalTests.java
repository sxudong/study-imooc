package com.SpringSourceAnalysis.ch10.transactional.xml;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 《Spring源码深度解析》第10章 事务
 *  P254
 */
public class TransactionalTests {
    public static void main(String[] args) throws Exception {
        ApplicationContext act = new ClassPathXmlApplicationContext("test/tx/applicationContext-tx.xml");
        UserService userService = (UserService) act.getBean("userService");
        User user = new User();
        user.setName("张三ccc");
        user.setAge(20);
        user.setSex("男");

        // 保存一条数据
        userService.save(user);
    }
}
/* Output:
Exception in thread "main" java.lang.RuntimeException: UserServiceImpl 事务异常！
	at com.SpringSourceAnalysis.ch10.transactional.UserServiceImpl.save(UserServiceImpl.java:26)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:343)
	at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
	at org.springframework.transaction.interceptor.TransactionAspectSupport.invokeWithinTransaction(TransactionAspectSupport.java:295)
	at org.springframework.transaction.interceptor.TransactionInterceptor.invoke(TransactionInterceptor.java:98)
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
	at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:212)
	at com.sun.proxy.$Proxy10.save(Unknown Source)
	at com.SpringSourceAnalysis.ch10.transactional.TransactionalTests.main(TransactionalTests.java:20)
*///~