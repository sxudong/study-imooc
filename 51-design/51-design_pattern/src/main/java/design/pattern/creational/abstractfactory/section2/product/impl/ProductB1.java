package design.pattern.creational.abstractfactory.section2.product.impl;

import design.pattern.creational.abstractfactory.section2.product.AbstractProductB;

/**
 * 产品B1的实现类
 */
public class ProductB1 extends AbstractProductB {

	@Override
	public void doSomething() {
		System.out.println("产品B1的实现方法");
	}

}
