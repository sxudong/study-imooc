package design.pattern.behavioral.observer.monitor.spring.event.listener;

import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

/**
 * 定义事件监听器。定义的事件监听器会在 spring 上下文初始化时，自动加载此 listener。
 */
@Component // 注册到 Spring IOC 容器中
public class MessageEventListener implements ApplicationListener<MessageEvent> {
    @Override
    public void onApplicationEvent(MessageEvent event) {
        System.out.printf("event.message=" + event.getContent());
    }
}