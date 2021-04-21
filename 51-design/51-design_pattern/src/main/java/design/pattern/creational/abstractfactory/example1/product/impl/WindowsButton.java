package design.pattern.creational.abstractfactory.example1.product.impl;

import design.pattern.creational.abstractfactory.example1.product.Button;

public class WindowsButton implements Button {
	@Override
	public void click() {
		System.out.println("Windows按钮被点击");
	}
}