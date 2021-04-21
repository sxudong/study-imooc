package design.pattern.creational.abstractfactory.section1.product.impl;

import design.pattern.creational.abstractfactory.section1.product.AbstractYellowHuman;

/**
 * 代码清单9-5 黄色女性人种
 */
public class FemaleYellowHuman extends AbstractYellowHuman {

	//黄人女性
	public void getSex() {
		System.out.println("黄人女性");
	}

}
