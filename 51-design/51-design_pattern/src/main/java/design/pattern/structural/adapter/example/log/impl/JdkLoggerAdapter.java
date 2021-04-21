package design.pattern.structural.adapter.example.log.impl;

import design.pattern.structural.adapter.example.log.Logger;

import java.util.logging.Level;

/**
 * JdkLoggerAdapter适配JDK日志
 */
public class JdkLoggerAdapter implements Logger {
	private java.util.logging.Logger logger;

	public JdkLoggerAdapter(java.util.logging.Logger logger) {
		this.logger = logger;
	}

	@Override
	public void trace(String message) {
		logger.log(Level.FINEST, message);
	}

	@Override
	public void debug(String message) {
		logger.log(Level.CONFIG, message);
	}

	@Override
	public void info(String message) {
		logger.log(Level.INFO, message);
	}

	@Override
	public void warn(String message) {
		logger.log(Level.WARNING, message);
	}

	@Override
	public void error(String message, Throwable t) {
		logger.log(Level.SEVERE, message, t);
	}
}
