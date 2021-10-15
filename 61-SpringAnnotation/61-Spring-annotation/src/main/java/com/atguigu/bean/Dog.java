package com.atguigu.bean;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

/**
 *  3）、可以使用JSR250；
 *  	@PostConstruct：在bean创建完成并且属性赋值完成；来执行初始化方法
 *  	@PreDestroy：在容器销毁bean之前通知我们进行清理工作
 *
 */
@Component
public class Dog implements ApplicationContextAware { // ApplicationContextAware 实现这个类可以注入IOC，通过它获取到IOC容器

	//@Autowired
	private ApplicationContext applicationContext;

	public Dog(){
		System.out.println("dog constructor...");
	}

	/**
	 * 对象创建并赋值之后调用
	 *
	 * 初始化
	 */
	@PostConstruct
	public void init(){
		System.out.println("Dog....@PostConstruct...");
	}

	/**
	 * 容器移除对象之前
	 *
	 * 销毁方法
	 */
	@PreDestroy
	public void detory(){
		System.out.println("Dog....@PreDestroy...");
	}

	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		// TODO Auto-generated method stub
		this.applicationContext = applicationContext;  // 获取容器
	}

}
