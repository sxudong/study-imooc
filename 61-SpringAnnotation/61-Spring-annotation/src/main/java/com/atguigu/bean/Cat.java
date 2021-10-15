package com.atguigu.bean;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

/**
 * 通过让Bean实现InitializingBean（定义初始化逻辑），DisposableBean（定义销毁逻辑）;
 */
@Component
public class Cat implements InitializingBean, DisposableBean {
	
	public Cat(){
		System.out.println("cat constructor...");
	}

	/**
	 * 销毁
	 */
	@Override
	public void destroy() throws Exception {
		// TODO Auto-generated method stub
		System.out.println("cat...destroy...");
	}

	/**
	 * 初始化
	 */
	@Override
	public void afterPropertiesSet() throws Exception {
		// TODO Auto-generated method stub
		System.out.println("cat...afterPropertiesSet...");
	}

}
