package com.atguigu.bean;

import org.springframework.stereotype.Component;

@Component
public class Car {
	
	public Car(){
		System.out.println("car constructor...");
	}

	/**
	 * 初始化方法
	 */
	public void init(){
		System.out.println("car ... init...");
	}

	/**
	 * 销毁方法
	 */
	public void detory(){
		System.out.println("car ... detory...");
	}

}
