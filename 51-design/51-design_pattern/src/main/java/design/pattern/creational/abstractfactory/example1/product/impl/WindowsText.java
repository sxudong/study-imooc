package design.pattern.creational.abstractfactory.example1.product.impl;

import design.pattern.creational.abstractfactory.example1.product.Text;

public class WindowsText implements Text {

	@Override
	public void display() {
		System.out.println("Windows文本框显示");
	}
}