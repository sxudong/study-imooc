package com.atguigu.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.ComponentScans;

import com.atguigu.bean.Person;

//@ComponentScan  value:指定要扫描的包
//excludeFilters = Filter[] ：指定扫描的时候按照什么规则排除那些组件
//includeFilters = Filter[] ：指定扫描的时候只需要包含哪些组件
//FilterType.ANNOTATION：按照注解
//FilterType.ASSIGNABLE_TYPE：按照给定的类型；
//FilterType.ASPECTJ：使用ASPECTJ表达式 //不常用，这里不说明了
//FilterType.REGEX：使用正则指定        //不常用，这里不说明了
//FilterType.CUSTOM：使用自定义规则


//配置类==配置文件
@Configuration  //告诉Spring这是一个配置类
//@ComponentScans( value = "com.atguigu")
@ComponentScans(
		value = {
				// @ComponentScan(value="com.atguigu",excludeFilters = { // 排除Controller        // excludeFilters = Filter[] ：指定扫描的时候按照什么规则排除那些组件
				@ComponentScan(value="com.atguigu",includeFilters = {                             // includeFilters = Filter[] ：指定扫描的时候只需要包含哪些组件
						// @Filter(type=FilterType.ANNOTATION,classes={Controller.class}),        // FilterType.ANNOTATION：按照注解
						// @Filter(type=FilterType.ASSIGNABLE_TYPE,classes={BookService.class}),  // FilterType.ASSIGNABLE_TYPE：按照给定的类型；
						@Filter(type=FilterType.CUSTOM,classes={MyTypeFilter.class})              // FilterType.CUSTOM：使用自定义规则
				},useDefaultFilters = false)
		}
)
public class MainConfig {

	//给容器中注册一个Bean;类型为返回值的类型，id默认是用方法名作为id
	@Bean("person")
	public Person person01(){
		return new Person("lisi", 20);
	}

}
