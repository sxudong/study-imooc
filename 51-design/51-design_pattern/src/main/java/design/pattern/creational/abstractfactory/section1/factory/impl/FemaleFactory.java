package design.pattern.creational.abstractfactory.section1.factory.impl;

import design.pattern.creational.abstractfactory.section1.product.impl.FemaleBlackHuman;
import design.pattern.creational.abstractfactory.section1.product.impl.FemaleWhiteHuman;
import design.pattern.creational.abstractfactory.section1.product.impl.FemaleYellowHuman;
import design.pattern.creational.abstractfactory.section1.product.Human;
import design.pattern.creational.abstractfactory.section1.factory.HumanFactory;

/**
 * 代码清单9-8 生产女性的八卦炉
 *
 * 女性工厂
 */
public class FemaleFactory implements HumanFactory {
	//生产出黑人女性
	public Human createBlackHuman() {
		return new FemaleBlackHuman();
	}

	//生产出白人女性
	public Human createWhiteHuman() {	
		return new FemaleWhiteHuman();
	}

	//生产出黄人女性
	public Human createYellowHuman() {
		return new FemaleYellowHuman();
	}

}
