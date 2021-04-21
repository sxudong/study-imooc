package design.pattern.behavioral.observer.exemple.observer.impl;

import design.pattern.behavioral.observer.exemple.observer.Observer;

public class Sms implements Observer {

	@Override
	public void update() {
		System.out.println("账户扣款短信通知...");
	}
}