package design.pattern.creational.abstractfactory.section2.product.impl;

import design.pattern.creational.abstractfactory.section2.product.AbstractProductA;

/**
 * 代码清单9-12 产品A1的实现类
 */
public class ProductA1 extends AbstractProductA {

	@Override
	public void doSomething() {
		System.out.println("产品A1的实现方法");
	}

}
