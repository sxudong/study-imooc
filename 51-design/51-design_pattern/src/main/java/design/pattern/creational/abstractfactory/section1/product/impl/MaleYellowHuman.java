package design.pattern.creational.abstractfactory.section1.product.impl;

import design.pattern.creational.abstractfactory.section1.product.AbstractYellowHuman;

/**
 * 代码清单9-6 黄色男性人种
 */
public class MaleYellowHuman extends AbstractYellowHuman {

	//黄人男性
	public void getSex() {
		System.out.println("黄人男性");
	}

}
