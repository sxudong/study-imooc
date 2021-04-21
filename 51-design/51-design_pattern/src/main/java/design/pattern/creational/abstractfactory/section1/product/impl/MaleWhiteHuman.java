package design.pattern.creational.abstractfactory.section1.product.impl;

import design.pattern.creational.abstractfactory.section1.product.AbstractWhiteHuman;

/**
 * 白色男性人种
 */
public class MaleWhiteHuman extends AbstractWhiteHuman {

	//白人男性
	public void getSex() {
		System.out.println("白人男性");
	}

}
