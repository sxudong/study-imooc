package com.atguigu.test;

import org.junit.Test;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import tx.TxConfig;
import tx.UserService;

public class IOCTest_Tx {

	@Test
	public void test01(){
		// 创建基于注解的 SpringIOC 容器
		AnnotationConfigApplicationContext applicationContext =
				new AnnotationConfigApplicationContext(TxConfig.class);

		UserService userService = applicationContext.getBean(UserService.class);

		userService.insertUser();
		applicationContext.close();
	}

}
/* Output:
插入完成...

java.lang.ArithmeticException: / by zero

	at com.atguigu.tx.UserService.insertUser(UserService.java:19)
*///~
