package design.pattern.creational.abstractfactory.section2.factory.impl;

import design.pattern.creational.abstractfactory.section2.factory.AbstractCreator;
import design.pattern.creational.abstractfactory.section2.product.AbstractProductA;
import design.pattern.creational.abstractfactory.section2.product.AbstractProductB;
import design.pattern.creational.abstractfactory.section2.product.impl.ProductA2;
import design.pattern.creational.abstractfactory.section2.product.impl.ProductB2;

/**
 * 代码清单9-16 产品等级2的实现类
 */
public class Creator2 extends AbstractCreator {
	
	//创建A产品家族，只生产产品等级为2的A产品
	public AbstractProductA createProductA() {
		return new ProductA2();
	}

	//创建B产品家族，只生产产品等级为2的B产品
	public AbstractProductB createProductB() {
		return new ProductB2();
	}
}
