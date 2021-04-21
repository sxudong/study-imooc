package design.pattern.behavioral.observer.monitor.spring.event.listener;

import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

/**
 * 使用 Spring 自带的 ContextRefreshedEvent事件 实现自定义 Listener
 */
@Component
public class MyListener implements ApplicationListener<ContextRefreshedEvent> {
    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        System.out.println("容器中初始化Bean数量:" + event.getApplicationContext().getBeanDefinitionCount());
    }
}