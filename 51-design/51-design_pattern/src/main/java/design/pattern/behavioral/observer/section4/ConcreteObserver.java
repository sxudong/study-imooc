package design.pattern.behavioral.observer.section4;

/**
 * 具体的观察者
 */
public class ConcreteObserver implements Observer {

	//实现更新方法
	public void update() {
		System.out.println("接收到信息，并进行处理！");
	}

}
