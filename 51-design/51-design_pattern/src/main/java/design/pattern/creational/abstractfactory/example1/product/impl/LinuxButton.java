package design.pattern.creational.abstractfactory.example1.product.impl;

import design.pattern.creational.abstractfactory.example1.product.Button;

public class LinuxButton implements Button {
	@Override
	public void click() {
		System.out.println("Linux按钮被点击");
	}
}