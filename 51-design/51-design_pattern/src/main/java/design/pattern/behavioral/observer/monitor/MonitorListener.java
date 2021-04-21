package design.pattern.behavioral.observer.monitor;

import java.util.EventListener;

/**
 * 事件监听器（Observer观察者）
 *
 * EventListener: A tagging interface that all event listener interfaces must extend.
 * 所有事件监听器接口都要继承这个标签接口
 */
public interface MonitorListener extends EventListener {
	/*
	 * The root class from which all event state objects shall be derived.
	 * All Events are constructed with a reference to the object, the "source",
	 * that is logically deemed to be the object upon which the Event in
	 * question initially occurred upon.
	 * 从中派生所有事件状态对象的根类。所有事件均以对对象“源”的引用构造而成，该对象
	 * 在逻辑上被认为是所讨论事件最初在其上发生的对象。
	 */
	public void handleEvent(PrintEvent event);
}