package design.pattern.creational.abstractfactory.section2.factory.impl;

import design.pattern.creational.abstractfactory.section2.factory.AbstractCreator;
import design.pattern.creational.abstractfactory.section2.product.AbstractProductA;
import design.pattern.creational.abstractfactory.section2.product.AbstractProductB;
import design.pattern.creational.abstractfactory.section2.product.impl.ProductA1;
import design.pattern.creational.abstractfactory.section2.product.impl.ProductB1;

/**
 * 代码清单9-15 产品等级1的实现类
 */
public class Creator1 extends AbstractCreator {
	
	//创建A产品家族，只生产产品等级为1的A产品
	public AbstractProductA createProductA() {
		return new ProductA1();
	}

	//创建B产品家族，只生产产品等级为1的B产品
	public AbstractProductB createProductB() {
		return new ProductB1();
	}

}