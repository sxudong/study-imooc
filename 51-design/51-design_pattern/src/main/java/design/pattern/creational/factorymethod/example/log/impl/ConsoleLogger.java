package design.pattern.creational.factorymethod.example.log.impl;

import design.pattern.creational.factorymethod.example.log.AbstractLogger;

/**
 * 将日志输出到控制台
 */
public class ConsoleLogger extends AbstractLogger {

	public ConsoleLogger(String name) {
		super(name);
	}

	@Override
	public void debug(String message) {
		System.out.println(name + " -- " + message);
	}

	@Override
	public void error(String message) {
		System.err.println(name + " -- " + message);
	}
}
