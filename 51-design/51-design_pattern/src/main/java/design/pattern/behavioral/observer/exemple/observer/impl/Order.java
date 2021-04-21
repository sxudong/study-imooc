package design.pattern.behavioral.observer.exemple.observer.impl;

import design.pattern.behavioral.observer.exemple.observer.Observer;

public class Order implements Observer {

	@Override
	public void update() {
		System.out.println("修改订单状态...");
	}
}




