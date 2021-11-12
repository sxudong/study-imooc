package com.SpringSourceAnalysis.mybatis;

import com.SpringSourceAnalysis.ch09.mybatis.pojo.User;
import com.SpringSourceAnalysis.ch09.mybatis.mapper.UserMapper;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 《Spring源码深度解析》第9章 整合Mybatis
 *
 * 使用的是 spring-mybatis jar包
 */
public class SpringMybatisTests {

	@Test
	public void TestMapperFactory(){
		ApplicationContext context = new ClassPathXmlApplicationContext("test/mybatis/spring-mapperFactory.xml");
		UserMapper userMapper = (UserMapper)context.getBean("userMapper");
		User user = userMapper.getUser(1);
		System.out.println("name:"+user.getName()+",age:"+user.getAge());
		((ClassPathXmlApplicationContext)context).close();
	}
	/* Output:
    name:张三,age:20
    *///~

	@Test
	public void TestMapperScannerConfigurer(){
		ApplicationContext context = new ClassPathXmlApplicationContext("test/mybatis/spring-mapperScannerConfigurer.xml");
		UserMapper userMapper = (UserMapper)context.getBean("userMapper");
		User user = userMapper.getUser(1);
		System.out.println("name:"+user.getName()+",age:"+user.getAge());
		((ClassPathXmlApplicationContext)context).close();
	}
	/* Output:
	name:张三,age:20
	*///~
}
