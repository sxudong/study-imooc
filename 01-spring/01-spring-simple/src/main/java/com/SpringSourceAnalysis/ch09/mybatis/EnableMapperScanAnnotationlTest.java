package com.SpringSourceAnalysis.ch09.mybatis;

import com.SpringSourceAnalysis.ch09.mybatis.config.MyBatisConfig;
import com.SpringSourceAnalysis.ch09.mybatis.mapper.UserMapper;
import com.SpringSourceAnalysis.ch09.mybatis.pojo.User;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

/**
 * 《Spring源码深度解析》第9章 整合Mybatis
 *
 * 使用的是 spring-mybatis jar包，测试注解 @MapperScan
 */
public class EnableMapperScanAnnotationlTest {
	public static void main(String[] args) {
		ApplicationContext context = new AnnotationConfigApplicationContext(MyBatisConfig.class);
		UserMapper userMapper = (UserMapper)context.getBean("userMapper");
		User user = userMapper.getUser(1);
		System.out.println("name:"+user.getName()+",age:"+user.getAge());
		((AnnotationConfigApplicationContext)context).close();
	}
}
/* Output:
name:张三,age:20
*///~