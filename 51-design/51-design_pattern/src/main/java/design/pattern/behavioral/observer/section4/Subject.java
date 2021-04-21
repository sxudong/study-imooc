package design.pattern.behavioral.observer.section4;

import java.util.Vector;

/**
 * 被观察者接口
 */
public abstract class Subject {
	//定一个一个观察者数组
	private Vector<Observer> obsVector = new Vector<Observer>();
	
	//增加一个观察者
	public void addObserver(Observer o){
		this.obsVector.add(o);
	}
	
	//删除一个观察者
	public void delObserver(Observer o){
		this.obsVector.remove(o);
	}
	
	//通知所有观察者
	public void notifyObserver(){
		for(Observer o:this.obsVector){
			o.update();
		}
	}
}
