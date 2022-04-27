package com.atguigu.config.sequence;

import org.springframework.context.annotation.*;


/**
 * 测试 @Component 和 @Configuration 的加载顺序
 */
@Configuration
@ComponentScan( value = "com.atguigu.config.sequence")
public class TestSequenceConfig {

	//给容器中注册一个Bean;类型为返回值的类型，id默认是用方法名作为id
	@Bean("user")
	public User person01(){
		return new User();
	}

}
