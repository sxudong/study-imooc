package design.pattern.creational.abstractfactory.example1.factory;

import design.pattern.creational.abstractfactory.example1.product.Button;
import design.pattern.creational.abstractfactory.example1.product.Chart;
import design.pattern.creational.abstractfactory.example1.product.Text;

/**
 * 产品族工厂
 */
public interface ComponentFactory {

	// 生产按钮
	Button createButton();

	// 生产文本框
	Text createText();

	// 生产图表
	Chart createChart();
}