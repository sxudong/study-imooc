package design.pattern.behavioral.strategy.example;

import design.pattern.behavioral.strategy.example.log.Logger;

public class LogContext {
	private Logger logger;

	// 设置日志策略
	public void setLogger(Logger logger) {
		this.logger = logger;
	}

	public void doSomething(String arg) {
		logger.log(arg);
	}
}
