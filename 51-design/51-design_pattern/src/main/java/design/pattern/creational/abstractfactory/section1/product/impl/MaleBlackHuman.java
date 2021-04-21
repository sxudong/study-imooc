package design.pattern.creational.abstractfactory.section1.product.impl;

import design.pattern.creational.abstractfactory.section1.product.AbstractBlackHuman;

/**
 * 黑色男性人种
 */
public class MaleBlackHuman extends AbstractBlackHuman {

	//男性黑人
	public void getSex() {
		System.out.println("黑人男性");
	}

}
