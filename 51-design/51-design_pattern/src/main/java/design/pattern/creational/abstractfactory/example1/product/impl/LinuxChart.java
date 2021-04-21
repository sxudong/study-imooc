package design.pattern.creational.abstractfactory.example1.product.impl;

import design.pattern.creational.abstractfactory.example1.product.Chart;

public class LinuxChart implements Chart {
	@Override
	public void show() {
		System.out.println("Linux图表展示");
	}
}