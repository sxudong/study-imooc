package design.pattern.creational.factorymethod.example.factory.impl;

import design.pattern.creational.factorymethod.example.factory.LoggerFactory;
import design.pattern.creational.factorymethod.example.log.impl.ConsoleLogger;
import design.pattern.creational.factorymethod.example.log.Logger;

/**
 * 专门生产控制台日志的工厂
 */
public class ConsoleLoggerFactory implements LoggerFactory {

	@Override
	public Logger getLogger(String name) {
		return new ConsoleLogger(name);
	}
}
