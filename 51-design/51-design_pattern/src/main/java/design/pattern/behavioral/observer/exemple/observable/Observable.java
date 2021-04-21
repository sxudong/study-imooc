package design.pattern.behavioral.observer.exemple.observable;

import design.pattern.behavioral.observer.exemple.observer.Observer;

import java.util.ArrayList;
import java.util.List;

/**
 * 被观察者接口
 */
public abstract class Observable {
	// 观察者列表
	private List<Observer> observers = new ArrayList<>();

	// 添加观察者
	public void add(Observer observer){
		observers.add(observer);
	}

	// 移除观察者
	public void remove(Observer observer){
		observers.remove(observer);
	}

	// 通知观察者
	protected void notifyObservers(){
		for (Observer observer : observers) {
			observer.update();
		}
	}
}
