package com.atguigu.test;

import java.util.Map;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;

import com.atguigu.bean.Blue;
import com.atguigu.bean.Person;
import com.atguigu.config.MainConfig;
import com.atguigu.config.MainConfig2;

public class IOCTest {
	// 创建基于注解的 SpringIOC 容器
	AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(MainConfig2.class);
	//创建基于配置文件的 SpringIOC 容器
	//ApplicationContext xmlApplicationContext = new ClassPathXmlApplicationContext("/spring-beans.xml");

	@SuppressWarnings("resource")
	@Test
	public void test01(){
		AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(MainConfig.class);
		String[] definitionNames = applicationContext.getBeanDefinitionNames();
		for (String name : definitionNames) {
			System.out.println(name);
		}
	}

	@Test
	public void test02(){
		AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(MainConfig2.class);
//		String[] definitionNames = applicationContext.getBeanDefinitionNames();
//		for (String name : definitionNames) {
//			System.out.println(name);
//		}
//
		System.out.println("ioc容器创建完成....");
		Object bean = applicationContext.getBean("person");
		Object bean2 = applicationContext.getBean("person");
		System.out.println(bean == bean2);
	}


	// VM arguments: -Dos.name=linux  // 把系统变成linux
	@Test
	public void test03(){
		// 容器中有几个人
		String[] namesForType = applicationContext.getBeanNamesForType(Person.class);
		ConfigurableEnvironment environment = applicationContext.getEnvironment();
		//动态获取环境变量的值；Windows 10
		String property = environment.getProperty("os.name");
		System.out.println("操作系统环境：" + property);

		System.out.println("容器中有几个人:");
		for (String name : namesForType) {
			System.out.println(name);
		}

		System.out.println("=====================================");
		Map<String, Person> persons = applicationContext.getBeansOfType(Person.class);
		System.out.println(persons);

	}

	@Test
	public void testImport(){
		System.out.println("================= Import ====================");
		// 打印Import导入的bean,ID默认是全类名
		printBeans(applicationContext);

		System.out.println("================= ImportSelector ====================");
		// 打印 MyImportSelector selectImports导入的bean,ID默认是全类名
		Blue bean = applicationContext.getBean(Blue.class);
		System.out.println(bean);

		System.out.println("================== 工厂Bean获取 ===================");
		//工厂Bean获取的是调用getObject创建的对象
		Object bean2 = applicationContext.getBean("colorFactoryBean");
		Object bean3 = applicationContext.getBean("colorFactoryBean");
		System.out.println("bean的类型：" + bean2.getClass()); // bean的类型：class com.atguigu.bean.Color
		System.out.println(bean2 == bean3); // false

		// 加一个前缀"&"，根据id获取BeanFactory本身的实例
		Object bean4 = applicationContext.getBean("&colorFactoryBean");
		System.out.println(bean4.getClass()); // class com.atguigu.bean.ColorFactoryBean

		System.out.println(applicationContext.getBean("rainBow").getClass().getName()); // com.atguigu.bean.RainBo
	}

	private void printBeans(AnnotationConfigApplicationContext applicationContext){
		String[] definitionNames = applicationContext.getBeanDefinitionNames();
		for (String name : definitionNames) {
			System.out.println(name);
		}
	}
}
