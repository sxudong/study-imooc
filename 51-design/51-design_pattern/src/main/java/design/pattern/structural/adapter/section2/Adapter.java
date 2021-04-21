package design.pattern.structural.adapter.section2;

/**
 * 适配器
 */
public class Adapter extends Adaptee implements Target {
	
	public void request() {
		super.doSomething();
	}

}
