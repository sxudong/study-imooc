package com.atguigu.condition;

import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.context.annotation.ImportBeanDefinitionRegistrar;
import org.springframework.core.type.AnnotationMetadata;

import com.atguigu.bean.RainBow;

/**
 * 单元测试类：com.atguigu.test.IOCTest.test02()
 */
public class MyImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {

	/**
	 * AnnotationMetadata：当前类的注解信息
	 * BeanDefinitionRegistry:BeanDefinition注册类；
	 * 		把所有需要添加到容器中的bean；调用
	 * 		BeanDefinitionRegistry.registerBeanDefinition手工注册进来
	 */
	@Override
	public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {

		System.out.println("当前类的注解信息" + importingClassMetadata.getClassName());
		// 输出：当前类的注解信息com.atguigu.config.MainConfig2

		// 容器中是否有 com.atguigu.bean.Red
		boolean definition = registry.containsBeanDefinition("com.atguigu.bean.Red");
		boolean definition2 = registry.containsBeanDefinition("com.atguigu.bean.Blue");
		// 如果这俩都有
		if(definition && definition2){
			//指定Bean定义信息；（Bean的类型，Bean。。。）
			RootBeanDefinition beanDefinition = new RootBeanDefinition(RainBow.class); // 要注册的bean
			//注册一个Bean，指定bean名
			registry.registerBeanDefinition("rainBow", beanDefinition);
		}
	}

}
