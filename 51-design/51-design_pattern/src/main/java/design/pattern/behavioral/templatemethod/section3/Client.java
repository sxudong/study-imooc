package design.pattern.behavioral.templatemethod.section3;

/**
 * 设计模式之禅——模板方法模式
 */
public class Client {
	
	public static void main(String[] args) {
		AbstractClass class1 = new ConcreteClass1();
		AbstractClass class2 = new ConcreteClass2();
		
		//调用模版方法
		class1.templateMethod();
		class2.templateMethod();
	}
}
