package com.atguigu.test;

import org.junit.Test;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.atguigu.aop.MathCalculator;
import com.atguigu.bean.Boss;
import com.atguigu.bean.Car;
import com.atguigu.bean.Color;
import com.atguigu.bean.Red;
import com.atguigu.config.MainConfigOfAOP;
import com.atguigu.config.MainConifgOfAutowired;
import com.atguigu.dao.BookDao;
import ext.ExtConfig;
import com.atguigu.service.BookService;

public class IOCTest_Ext {

	@Test
	public void test01(){
		AnnotationConfigApplicationContext applicationContext  =
				new AnnotationConfigApplicationContext(ExtConfig.class);

		applicationContext.close();
	}

	@Test
	public void test02(){
		// 创建基于注解的 SpringIOC 容器
		AnnotationConfigApplicationContext applicationContext  =
				new AnnotationConfigApplicationContext(ExtConfig.class);

		// 发布事件
		applicationContext.publishEvent(new ApplicationEvent(new String("我发布的时间")) {
		});

		applicationContext.close();
	}
}
/* Output:
postProcessBeanDefinitionRegistry...bean的数量：11
MyBeanDefinitionRegistryPostProcessor...bean的数量：12
MyBeanFactoryPostProcessor...postProcessBeanFactory...
当前BeanFactory中有12 个Bean
[org.springframework.context.annotation.internalConfigurationAnnotationProcessor, org.springframework.context.annotation.internalAutowiredAnnotationProcessor, org.springframework.context.annotation.internalRequiredAnnotationProcessor, org.springframework.context.annotation.internalCommonAnnotationProcessor, org.springframework.context.event.internalEventListenerProcessor, org.springframework.context.event.internalEventListenerFactory, extConfig, myApplicationListener, myBeanDefinitionRegistryPostProcessor, myBeanFactoryPostProcessor, blue, hello]
blue...constructor
blue...constructor
收到事件：org.springframework.context.event.ContextRefreshedEvent[source=org.springframework.context.annotation.AnnotationConfigApplicationContext@3339ad8e: startup date [Fri Jul 24 14:14:14 CST 2020]; root of context hierarchy]
收到事件：com.atguigu.test.IOCTest_Ext$1[source=我发布的时间]
收到事件：org.springframework.context.event.ContextClosedEvent[source=org.springframework.context.annotation.AnnotationConfigApplicationContext@3339ad8e: startup date [Fri Jul 24 14:14:14 CST 2020]; root of context hierarchy]
*///~