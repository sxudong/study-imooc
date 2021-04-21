package design.pattern.structural.decorator.section3;

/**
 * 《设计模式之禅》—— 装饰模式
 */
public class Client {
	
	public static void main(String[] args) {
		Component component = new ConcreteComponent();
		
		//第一次修饰
		component = new ConcreteDecorator1(component);
		//第二次修饰
		component = new ConcreteDecorator2(component);
		
		//修饰后运行
		component.operate();
	}
}
/* Output:
method1 修饰
do Something
method2修饰
 */