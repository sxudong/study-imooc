package design.pattern.creational.factorymethod.example.factory;

import design.pattern.creational.factorymethod.example.log.Logger;

/**
 * 日志工厂接口
 */
public interface LoggerFactory {
	// 获取日志记录器
	Logger getLogger(String name);
}