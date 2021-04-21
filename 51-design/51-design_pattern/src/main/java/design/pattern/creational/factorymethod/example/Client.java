package design.pattern.creational.factorymethod.example;

import design.pattern.creational.factorymethod.example.factory.impl.FileLoggerFactory;
import design.pattern.creational.factorymethod.example.factory.LoggerFactory;
import design.pattern.creational.factorymethod.example.log.Logger;

/**
 * 工厂方法模式-日志工厂
 * https://javap.blog.csdn.net/article/details/111655795
 * 需求：设计一个灵活的日志系统呢
 */
public class Client {
	public static void main(String[] args) {
		LoggerFactory factory = new FileLoggerFactory();
		Logger logger = factory.getLogger(Client.class.getName());
		logger.error("哈哈");
	}
}
/* F:\code\design_pattern\logs\error.log
design.pattern.creational.factorymethod.example.Client -- 哈哈
 */