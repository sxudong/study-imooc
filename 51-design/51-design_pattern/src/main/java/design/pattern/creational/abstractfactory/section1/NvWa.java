package design.pattern.creational.abstractfactory.section1;


import design.pattern.creational.abstractfactory.section1.factory.HumanFactory;
import design.pattern.creational.abstractfactory.section1.factory.impl.FemaleFactory;
import design.pattern.creational.abstractfactory.section1.factory.impl.MaleFactory;
import design.pattern.creational.abstractfactory.section1.product.Human;

/**
 * 代码清单9-10 女娲重造人类
 *
 * 女娲建立起了两条生产线，分别是：
 *   男性生产线
 *   女性生产线
 */
public class NvWa {
	public static void main(String[] args) {
		
		//第一条生产线，男性生产线
		HumanFactory maleHumanFactory = new MaleFactory();
		
		//第二条生产线，女性生产线
		HumanFactory femaleHumanFactory = new FemaleFactory();
		
		//生产线建立完毕，开始生产人了:
		Human maleYellowHuman = maleHumanFactory.createYellowHuman();
		
		Human femaleYellowHuman = femaleHumanFactory.createYellowHuman();

		System.out.println("---生产一个黄色女性---");
		femaleYellowHuman.getColor();
		femaleYellowHuman.talk();
		femaleYellowHuman.getSex();
		
		System.out.println("\n---生产一个黄色男性---");
		maleYellowHuman.getColor();
		maleYellowHuman.talk();
		maleYellowHuman.getSex();

		/*
		 * .....
		 * 后面你可以续了
		 */
	}
}
