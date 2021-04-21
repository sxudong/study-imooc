package design.pattern.behavioral.observer.guava;

import com.google.common.eventbus.EventBus;

/**
 * 通过 guava 实现一个观察者模式
 * EventBus 是 guava 提供的观察者核心类
 */
public class GuavaEventTest {
    public static void main(String[] args) {

        EventBus eventBus = new EventBus();       // 创建一个事件总线
        GuavaEvent guavaEvent = new GuavaEvent(); // 创建一个事件
        eventBus.register(guavaEvent);            // 注册事件
        eventBus.post("post的内容");        // 执行
    }
}
/* Output:
执行subscribe方法，传入的参数是：post的内容
 */