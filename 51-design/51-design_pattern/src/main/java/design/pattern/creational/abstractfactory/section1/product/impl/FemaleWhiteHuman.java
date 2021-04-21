package design.pattern.creational.abstractfactory.section1.product.impl;

import design.pattern.creational.abstractfactory.section1.product.AbstractWhiteHuman;

/**
 * 白色女性人种
 */
public class FemaleWhiteHuman extends AbstractWhiteHuman {

	//白人女性
	public void getSex() {
		System.out.println("白人女性");
	}

}
