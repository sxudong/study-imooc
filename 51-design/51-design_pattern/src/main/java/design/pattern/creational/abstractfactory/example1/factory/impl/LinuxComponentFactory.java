package design.pattern.creational.abstractfactory.example1.factory.impl;

import design.pattern.creational.abstractfactory.example1.factory.ComponentFactory;
import design.pattern.creational.abstractfactory.example1.product.Button;
import design.pattern.creational.abstractfactory.example1.product.Chart;
import design.pattern.creational.abstractfactory.example1.product.Text;
import design.pattern.creational.abstractfactory.example1.product.impl.LinuxButton;
import design.pattern.creational.abstractfactory.example1.product.impl.LinuxChart;
import design.pattern.creational.abstractfactory.example1.product.impl.LinuxText;

// Linux组件工厂
public class LinuxComponentFactory implements ComponentFactory{

	@Override
	public Button createButton() {
		return new LinuxButton();
	}

	@Override
	public Text createText() {
		return new LinuxText();
	}

	@Override
	public Chart createChart() {
		return new LinuxChart();
	}
}