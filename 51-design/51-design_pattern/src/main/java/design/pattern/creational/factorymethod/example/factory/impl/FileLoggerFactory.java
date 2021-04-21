package design.pattern.creational.factorymethod.example.factory.impl;

import design.pattern.creational.factorymethod.example.factory.LoggerFactory;
import design.pattern.creational.factorymethod.example.log.impl.FileLogger;
import design.pattern.creational.factorymethod.example.log.Logger;

/**
 * 专门生产文件日志的工厂
 */
public class FileLoggerFactory implements LoggerFactory {

	@Override
	public Logger getLogger(String name) {
		return new FileLogger(name);
	}
}
