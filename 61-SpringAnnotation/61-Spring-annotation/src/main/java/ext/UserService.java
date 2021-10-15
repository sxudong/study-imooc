package ext;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

/**
 * 43、扩展原理 @EventListener 与 SmartInitializingSingleton
 * 使用 @EventListener 可以让任意方法都能监听事件
 */
@Service
public class UserService {

	@EventListener(classes={ApplicationEvent.class})
	public void listen(ApplicationEvent event){
		System.out.println("UserService。。监听到的事件："+event);
	}
}
/*
public class IOCTest_Ext {

	@Test
	public void test01(){
		AnnotationConfigApplicationContext applicationContext  =
				new AnnotationConfigApplicationContext(ExtConfig.class);

		// 发布事件
		applicationContext.publishEvent(new ApplicationEvent(new String("我发布的时间")) {
		});

		applicationContext.close();
	}
}
postProcessBeanDefinitionRegistry...bean的数量：12
MyBeanDefinitionRegistryPostProcessor...bean的数量：13
MyBeanFactoryPostProcessor...postProcessBeanFactory...
当前BeanFactory中有13 个Bean
[org.springframework.context.annotation.internalConfigurationAnnotationProcessor, org.springframework.context.annotation.internalAutowiredAnnotationProcessor, org.springframework.context.annotation.internalRequiredAnnotationProcessor, org.springframework.context.annotation.internalCommonAnnotationProcessor, org.springframework.context.event.internalEventListenerProcessor, org.springframework.context.event.internalEventListenerFactory, extConfig, myApplicationListener, myBeanDefinitionRegistryPostProcessor, myBeanFactoryPostProcessor, userService, blue, hello]
blue...constructor
blue...constructor
UserService。。监听到的事件：org.springframework.context.event.ContextRefreshedEvent[source=org.springframework.context.annotation.AnnotationConfigApplicationContext@3339ad8e: startup date [Fri Jul 24 14:17:42 CST 2020]; root of context hierarchy]
收到事件：org.springframework.context.event.ContextRefreshedEvent[source=org.springframework.context.annotation.AnnotationConfigApplicationContext@3339ad8e: startup date [Fri Jul 24 14:17:42 CST 2020]; root of context hierarchy]
UserService。。监听到的事件：com.atguigu.test.IOCTest_Ext$1[source=我发布的时间]
收到事件：com.atguigu.test.IOCTest_Ext$1[source=我发布的时间]
UserService。。监听到的事件：org.springframework.context.event.ContextClosedEvent[source=org.springframework.context.annotation.AnnotationConfigApplicationContext@3339ad8e: startup date [Fri Jul 24 14:17:42 CST 2020]; root of context hierarchy]
收到事件：org.springframework.context.event.ContextClosedEvent[source=org.springframework.context.annotation.AnnotationConfigApplicationContext@3339ad8e: startup date [Fri Jul 24 14:17:42 CST 2020]; root of context hierarchy]
*///~