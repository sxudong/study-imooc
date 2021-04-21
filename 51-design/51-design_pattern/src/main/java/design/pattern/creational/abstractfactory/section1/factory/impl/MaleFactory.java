package design.pattern.creational.abstractfactory.section1.factory.impl;

import design.pattern.creational.abstractfactory.section1.product.Human;
import design.pattern.creational.abstractfactory.section1.product.impl.MaleBlackHuman;
import design.pattern.creational.abstractfactory.section1.product.impl.MaleWhiteHuman;
import design.pattern.creational.abstractfactory.section1.product.impl.MaleYellowHuman;
import design.pattern.creational.abstractfactory.section1.factory.HumanFactory;

/**
 * 代码清单9-9 生产男性的八卦炉
 *
 * 男性工厂
 */
public class MaleFactory implements HumanFactory {
	//生产出黑人男性
	public Human createBlackHuman() {
		return new MaleBlackHuman();
	}

	//生产出白人男性
	public Human createWhiteHuman() {	
		return new MaleWhiteHuman();
	}

	//生产出黄人男性
	public Human createYellowHuman() {
		return new MaleYellowHuman();
	}

}
