package uml.aggregation;

/**
 * 类图—聚合关系（Aggregation）
 *
 * 表示的是整体和部分的关系，整体与部分可以分开。
 *
 * 例如：一台电脑由键盘(keyboard)、显示器(monitor)，鼠标等组成，组成电脑的各个配件是可以从电脑上分离出来的。
 * 下面的代码的形式，就是类中有一个属性，通过set方法为其赋值。这样的方式就是聚合关系。
 */
public class Computer{

	private Mouse mouse;
	private Monitor monitor;
	
	public void setMouse(Mouse mouse){
		this.mouse = mouse;
	}
	
	public void setMonitor(Monitor monitor){
		this.monitor = monitor;
	}

}

class Mouse{}
class Monitor{}