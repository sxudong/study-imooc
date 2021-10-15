package com.atguigu;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.atguigu.bean.Person;
import com.atguigu.config.MainConfig;

import java.util.HashMap;

public class MainTest {
	
	@SuppressWarnings("resource")
	public static void main(String[] args) {
//		ApplicationContext applicationContext = new ClassPathXmlApplicationContext("beans.xml");
//		Person bean = (Person) applicationContext.getBean("person");
//		System.out.println(bean); //Person [name=zhangsan, age=18]

		ApplicationContext applicationContext = new AnnotationConfigApplicationContext(MainConfig.class); //传配置类
		Person bean = applicationContext.getBean(Person.class);
		System.out.println(bean); //Person [name=lisi, age=20]

		String[] namesForType = applicationContext.getBeanNamesForType(Person.class);
		for (String name : namesForType) {
			System.out.println(name);
		}
	}
}
/* Output:
Person [name=张三, age=18, nickName=小李四  ]
person
*///~