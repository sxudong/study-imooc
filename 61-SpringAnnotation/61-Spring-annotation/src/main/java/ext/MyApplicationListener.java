package ext;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

/**
 * 42、扩展原理-ApplicationListener原理
 */
@Component
public class MyApplicationListener implements ApplicationListener<ApplicationEvent> {

    /**
     * 当容器中发布此事件以后，方法触发
     */
    @Override
    public void onApplicationEvent(ApplicationEvent event) {
        // TODO Auto-generated method stub
        System.out.println("收到事件：" + event);
    }
}
/*
public class IOCTest_Ext {

	@Test
	public void test01(){
		AnnotationConfigApplicationContext applicationContext  =
				new AnnotationConfigApplicationContext(ExtConfig.class);

		applicationContext.close();
	}
}
输出：ContextRefreshedEvent容器刷新完成事件 & ContextClosedEvent关闭事件
postProcessBeanDefinitionRegistry...bean的数量：11
MyBeanDefinitionRegistryPostProcessor...bean的数量：12
MyBeanFactoryPostProcessor...postProcessBeanFactory...
当前BeanFactory中有12 个Bean
[org.springframework.context.annotation.internalConfigurationAnnotationProcessor, org.springframework.context.annotation.internalAutowiredAnnotationProcessor, org.springframework.context.annotation.internalRequiredAnnotationProcessor, org.springframework.context.annotation.internalCommonAnnotationProcessor, org.springframework.context.event.internalEventListenerProcessor, org.springframework.context.event.internalEventListenerFactory, extConfig, myApplicationListener, myBeanDefinitionRegistryPostProcessor, myBeanFactoryPostProcessor, blue, hello]
blue...constructor
blue...constructor
收到事件：org.springframework.context.event.ContextRefreshedEvent[source=org.springframework.context.annotation.AnnotationConfigApplicationContext@3339ad8e: startup date [Fri Jul 24 14:09:46 CST 2020]; root of context hierarchy]
收到事件：org.springframework.context.event.ContextClosedEvent[source=org.springframework.context.annotation.AnnotationConfigApplicationContext@3339ad8e: startup date [Fri Jul 24 14:09:46 CST 2020]; root of context hierarchy]
*///~