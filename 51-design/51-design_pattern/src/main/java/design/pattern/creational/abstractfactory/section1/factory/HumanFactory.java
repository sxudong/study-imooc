package design.pattern.creational.abstractfactory.section1.factory;

import design.pattern.creational.abstractfactory.section1.product.Human;

/**
 * 代码清单9-7 八卦炉定义 产品族工厂
 *
 * 这次定一个接口，应该要造不同性别的人，需要不同的生产线
 * 那这个八卦炉必须可以制造男人和女人
 */
public interface HumanFactory {
	
	//制造一个黄色人种
	public Human createYellowHuman();
	
	//制造一个白色人种
	public Human createWhiteHuman();
	
	//制造一个黑色人种
	public Human createBlackHuman();
}
