package design.pattern.creational.abstractfactory.example1;

import design.pattern.creational.abstractfactory.example1.factory.ComponentFactory;
import design.pattern.creational.abstractfactory.example1.product.Button;
import design.pattern.creational.abstractfactory.example1.product.Chart;
import design.pattern.creational.abstractfactory.example1.product.Text;

/**
 * Application依赖于组件工厂生产组件
 */
public class Application {
	private Button button;
	private Text text;
	private Chart chart;

	public Application(ComponentFactory factory) {
		this.button = factory.createButton();
		this.text = factory.createText();
		this.chart = factory.createChart();
	}

	public void buttonClick(){
		button.click();
	}

	public void textDisplay(){
		text.display();
	}

	public void showChart(){
		chart.show();
	}
}