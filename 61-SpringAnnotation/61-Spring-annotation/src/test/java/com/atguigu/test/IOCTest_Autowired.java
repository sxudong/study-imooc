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
/* Output:
postProcessBeforeInitialization...org.springframework.context.event.internalEventListenerProcessor=>org.springframework.context.event.EventListenerMethodProcessor@2893de87
postProcessAfterInitialization...org.springframework.context.event.internalEventListenerProcessor=>org.springframework.context.event.EventListenerMethodProcessor@2893de87
postProcessBeforeInitialization...org.springframework.context.event.internalEventListenerFactory=>org.springframework.context.event.DefaultEventListenerFactory@2c34f934
postProcessAfterInitialization...org.springframework.context.event.internalEventListenerFactory=>org.springframework.context.event.DefaultEventListenerFactory@2c34f934
postProcessBeforeInitialization...mainConifgOfAutowired=>com.atguigu.config.MainConifgOfAutowired$$EnhancerBySpringCGLIB$$39deb59f@240237d2
postProcessAfterInitialization...mainConifgOfAutowired=>com.atguigu.config.MainConifgOfAutowired$$EnhancerBySpringCGLIB$$39deb59f@240237d2
postProcessBeforeInitialization...bookDao2=>BookDao [lable=2]
postProcessAfterInitialization...bookDao2=>BookDao [lable=2]
postProcessBeforeInitialization...bookService=>BookService [bookDao=BookDao [lable=2]]
postProcessAfterInitialization...bookService=>BookService [bookDao=BookDao [lable=2]]
postProcessBeforeInitialization...bookDao=>BookDao [lable=1]
postProcessAfterInitialization...bookDao=>BookDao [lable=1]
postProcessBeforeInitialization...bookController=>com.atguigu.controller.BookController@71c8becc
postProcessAfterInitialization...bookController=>com.atguigu.controller.BookController@71c8becc
car constructor...
postProcessBeforeInitialization...car=>com.atguigu.bean.Car@78047b92
postProcessAfterInitialization...car=>com.atguigu.bean.Car@78047b92
Boss...有参构造器
postProcessBeforeInitialization...boss=>Boss [car=com.atguigu.bean.Car@78047b92]
postProcessAfterInitialization...boss=>Boss [car=com.atguigu.bean.Car@78047b92]
cat constructor...
postProcessBeforeInitialization...cat=>com.atguigu.bean.Cat@2cbb3d47
cat...afterPropertiesSet...
postProcessAfterInitialization...cat=>com.atguigu.bean.Cat@2cbb3d47
dog constructor...
postProcessBeforeInitialization...dog=>com.atguigu.bean.Dog@2aa3cd93
Dog....@PostConstruct...
postProcessAfterInitialization...dog=>com.atguigu.bean.Dog@2aa3cd93
当前bean的名字：red
解析的字符串：你好 Windows 10 我是 360
传入的ioc：org.springframework.context.annotation.AnnotationConfigApplicationContext@532760d8: startup date [Wed Oct 27 17:35:41 CST 2021]; root of context hierarchy
postProcessBeforeInitialization...red=>com.atguigu.bean.Red@3911c2a7
postProcessAfterInitialization...red=>com.atguigu.bean.Red@3911c2a7
postProcessBeforeInitialization...color=>Color [car=com.atguigu.bean.Car@78047b92]
postProcessAfterInitialization...color=>Color [car=com.atguigu.bean.Car@78047b92]
BookService [bookDao=BookDao [lable=2]]
BookDao [lable=2]
Boss [car=com.atguigu.bean.Car@78047b92]
com.atguigu.bean.Car@78047b92
Color [car=com.atguigu.bean.Car@78047b92]
打印容器: org.springframework.context.annotation.AnnotationConfigApplicationContext@532760d8: startup date [Wed Oct 27 17:35:41 CST 2021]; root of context hierarchy
Dog....@PreDestroy...
cat...destroy...
*///~