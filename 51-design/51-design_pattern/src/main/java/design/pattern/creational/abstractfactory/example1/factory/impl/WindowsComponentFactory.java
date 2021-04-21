package design.pattern.creational.abstractfactory.example1.factory.impl;

import design.pattern.creational.abstractfactory.example1.factory.ComponentFactory;
import design.pattern.creational.abstractfactory.example1.product.Button;
import design.pattern.creational.abstractfactory.example1.product.Chart;
import design.pattern.creational.abstractfactory.example1.product.Text;
import design.pattern.creational.abstractfactory.example1.product.impl.WindowsButton;
import design.pattern.creational.abstractfactory.example1.product.impl.WindowsChart;
import design.pattern.creational.abstractfactory.example1.product.impl.WindowsText;

// Windows组件工厂
public class WindowsComponentFactory implements ComponentFactory {

	@Override
	public Button createButton() {
		return new WindowsButton();
	}

	@Override
	public Text createText() {
		return new WindowsText();
	}

	@Override
	public Chart createChart() {
		return new WindowsChart();
	}
}