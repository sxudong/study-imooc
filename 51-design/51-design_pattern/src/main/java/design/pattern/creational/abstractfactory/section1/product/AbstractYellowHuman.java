package design.pattern.creational.abstractfactory.section1.product;

/**
 * 代码清单9-4 黄色人种
 */
public abstract class AbstractYellowHuman implements Human {
	public void getColor(){
		System.out.println("黄色人种的皮肤颜色是黄色的！");
	}

	public void talk() {
		System.out.println("黄色人种会说话，一般说的都是双字节。");
	}
}
