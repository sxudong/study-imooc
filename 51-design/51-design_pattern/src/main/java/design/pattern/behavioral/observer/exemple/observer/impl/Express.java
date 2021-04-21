package design.pattern.behavioral.observer.exemple.observer.impl;

import design.pattern.behavioral.observer.exemple.observer.Observer;

public class Express implements Observer {

	@Override
	public void update() {
		System.out.println("物流开始备货...");
	}
}