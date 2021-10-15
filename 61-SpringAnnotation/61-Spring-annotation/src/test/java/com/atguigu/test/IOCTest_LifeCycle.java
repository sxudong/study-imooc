package com.atguigu.test;

import org.junit.Test;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.atguigu.config.MainConfigOfLifeCycle;

public class IOCTest_LifeCycle {

	/**
	 *  初始化：
	 *  	对象创建完成，并赋值好，调用初始化方法。。。
	 *
	 *  销毁：
	 *  	单实例：容器关闭的时候
	 *  	多实例：容器不会管理这个bean；容器不会调用销毁方法；
 	 */
	@Test
	public void test01(){
		//1、创建ioc容器
		AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(MainConfigOfLifeCycle.class);
		System.out.println("==> 容器创建完成...");

		/** 测试多实例bean，需要把 MainConfigOfLifeCycle配置类文件 中的多实例域 @Scope("prototype")打开，和下面的 applicationContext.getBean("car") 注释打开*/
		//applicationContext.getBean("car");  // 多实例bean获取时才会创建，容器不会管理这个bean；容器不会调用销毁方法；

		/** 2 测试 通过让Bean实现InitializingBean（定义初始化逻辑），DisposableBean（定义销毁逻辑），需打开 MainConfigOfLifeCycle配置类文件 @ComponentScan("com.atguigu.bean") 扫描 com.atguigu.bean.Cat bean  */

		/** 3 测试 可以使用JSR250 定义初始化逻辑，定义销毁逻辑，需打开 MainConfigOfLifeCycle配置类文件 @ComponentScan("com.atguigu.bean") 扫描 com.atguigu.bean.Dog bean  */

		/** 4 测试 BeanPostProcessor bean的后置处理器，在bean初始化前后进行一些处理工作；需打开 MainConfigOfLifeCycle配置类文件 @ComponentScan("com.atguigu.bean") 扫描 com.atguigu.bean.MyBeanPostProcessor bean  */

		//关闭容器
		applicationContext.close();
	}

}
