package design.pattern.behavioral.observer.monitor.spring.event.listener;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 测试发布事件和监听事件
 */
public class Excutor {

    public static void main(String[] args){
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:/applicationContext.xml");
         // 发布事件/触发事件
        context.publishEvent(new MessageEvent("执行完成"));
    }
} /* Output:
event.message=执行完成
*/