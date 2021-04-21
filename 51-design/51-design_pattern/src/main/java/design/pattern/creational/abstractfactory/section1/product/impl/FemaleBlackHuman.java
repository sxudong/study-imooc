package design.pattern.creational.abstractfactory.section1.product.impl;

import design.pattern.creational.abstractfactory.section1.product.AbstractBlackHuman;

/**
 * 黑色女性人种
 */
public class FemaleBlackHuman extends AbstractBlackHuman {

	//女性黑人
	public void getSex() {
		System.out.println("黑人女性");
	}

}
