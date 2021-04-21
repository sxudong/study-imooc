package design.pattern.structural.adapter.example.log.impl;

import design.pattern.structural.adapter.example.log.Logger;

/**
 * LogbackLoggerAdapter适配Logback日志
 */
public class LogbackLoggerAdapter implements Logger{
	private ch.qos.logback.classic.Logger logger;

	public LogbackLoggerAdapter(ch.qos.logback.classic.Logger logger) {
		this.logger = logger;
	}

	@Override
	public void trace(String message) {
		logger.trace(message);
	}

	@Override
	public void debug(String message) {
		logger.debug(message);
	}

	@Override
	public void info(String message) {
		logger.info(message);
	}

	@Override
	public void warn(String message) {
		logger.warn(message);
	}

	@Override
	public void error(String message, Throwable t) {
		logger.error(message, t);
	}
}
