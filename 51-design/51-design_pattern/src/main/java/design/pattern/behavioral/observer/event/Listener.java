package design.pattern.behavioral.observer.event;

/**
 * 观察者
 * 监听者: 每个监听者实现接口来接收事件,并负责从事件源订阅与取消订阅
 */
public interface Listener {
	public void onChange(Event event);
}