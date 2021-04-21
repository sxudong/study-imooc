package design.pattern.creational.abstractfactory.example1;

import design.pattern.creational.abstractfactory.example1.factory.impl.LinuxComponentFactory;
import design.pattern.creational.abstractfactory.example1.factory.impl.WindowsComponentFactory;

/**
 * 抽象工厂模式-多平台软件设计
 * https://javap.blog.csdn.net/article/details/111735483
 *
 * 场景：开发一款软件，要求是支持多个平台，代码还要尽可能的被复用。
 *      不管是哪个平台，软件的架构外观和功能都是一样的，只是不同的
 *      组件在不同的平台实现代码不一样而已。
 *
 * 需求：假设这个软件很简单，只由三部分构成：
 *    1.按钮
 *    2.文本框
 *    3.绚丽的图表
 */
public class Client {
	public static void main(String[] args) {
		Application windows = new Application(new WindowsComponentFactory());
		windows.buttonClick();
		windows.textDisplay();
		windows.showChart();

		Application linux = new Application(new LinuxComponentFactory());
		linux.buttonClick();
		linux.textDisplay();
		linux.showChart();
	}
}
/* Output:
Windows按钮被点击
Windows文本框显示
Windows图表展示
Linux按钮被点击
Linux文本框显示
Linux图表展示
 */