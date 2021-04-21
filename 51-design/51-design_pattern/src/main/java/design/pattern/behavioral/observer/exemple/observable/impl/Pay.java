package design.pattern.behavioral.observer.exemple.observable.impl;

import design.pattern.behavioral.observer.exemple.observable.Observable;

/**
 * Pay就是个被观察者，只要用户支付成功，它就要去通知所有的观察者了。
 */
public class Pay extends Observable {
	public void pay(){
		System.out.println("支付完成.");
		// 通知观察者
		super.notifyObservers();
	}
}
