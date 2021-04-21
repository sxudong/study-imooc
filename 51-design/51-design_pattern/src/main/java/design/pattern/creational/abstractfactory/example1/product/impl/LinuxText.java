package design.pattern.creational.abstractfactory.example1.product.impl;

import design.pattern.creational.abstractfactory.example1.product.Text;

public class LinuxText implements Text {
	@Override
	public void display() {
		System.out.println("Linux文本框显示");
	}
}