package design.pattern.creational.abstractfactory.example1.product.impl;

import design.pattern.creational.abstractfactory.example1.product.Chart;

public class WindowsChart implements Chart {
	@Override
	public void show() {
		System.out.println("Windows图表展示");
	}
}
