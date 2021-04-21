package design.pattern.creational.abstractfactory.section2.product;

/**
 * 代码清单9-11 抽象产品类A
 */
public abstract class AbstractProductA {
	
	//每个产品共有的方法
	public void shareMethod(){
		
	}
	
	//每个产品相同方法，不同实现
	public abstract void doSomething();
}
