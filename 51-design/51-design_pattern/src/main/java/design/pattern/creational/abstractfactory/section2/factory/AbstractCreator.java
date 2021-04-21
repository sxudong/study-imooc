package design.pattern.creational.abstractfactory.section2.factory;

import design.pattern.creational.abstractfactory.section2.product.AbstractProductA;
import design.pattern.creational.abstractfactory.section2.product.AbstractProductB;

/**
 * 代码清单9-14 抽象工厂类
 */
public abstract class AbstractCreator {

	//创建A产品家族
	public abstract AbstractProductA createProductA();
	
	//创建B产品家族
	public abstract AbstractProductB createProductB();
}
