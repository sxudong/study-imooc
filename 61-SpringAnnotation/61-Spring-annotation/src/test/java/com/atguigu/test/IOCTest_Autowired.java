package com.atguigu.test;

import org.junit.Test;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.atguigu.bean.Boss;
import com.atguigu.bean.Car;
import com.atguigu.bean.Color;
import com.atguigu.bean.Red;
import com.atguigu.config.MainConifgOfAutowired;
import com.atguigu.dao.BookDao;
import com.atguigu.service.BookService;

public class IOCTest_Autowired {

	/**
	 * com.atguigu.service.BookService
	 * com.atguigu.dao.BookDao
	 */
	@Test
	public void test01(){
		AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(MainConifgOfAutowired.class);
		
		BookService bookService = applicationContext.getBean(BookService.class);
		System.out.println(bookService); // toString()方法中打印引扩的 BookDao
		
		BookDao bean = applicationContext.getBean(BookDao.class);
		System.out.println(bean);
		
		Boss boss = applicationContext.getBean(Boss.class);
		System.out.println(boss); // toString()打印的是car
		Car car = applicationContext.getBean(Car.class);
		System.out.println(car);  // boss中的car和容器中拿到的cat是一样的

		Color color = applicationContext.getBean(Color.class);
		System.out.println(color);

		System.out.println("打印容器: " + applicationContext);
		applicationContext.close();
	}

}
