package design.pattern.structural.adapter.example.log.impl;

import design.pattern.structural.adapter.example.log.Logger;

/**
 * Log4jLoggerAdapter适配Log4j日志
 *
 * 需要用到2个jar包：
 * 	<dependency>
 * 		<groupId>log4j</groupId>
 * 		<artifactId>log4j</artifactId>
 * 		<version>1.2.17</version>
 * 	</dependency>
 * 	<dependency>
 * 		<groupId>org.apache.logging.log4j</groupId>
 * 		<artifactId>log4j-core</artifactId>
 * 		<version>2.12.1</version>
 * 	</dependency>
 */
public class Log4jLoggerAdapter implements Logger{
	private org.apache.log4j.Logger logger;

	public Log4jLoggerAdapter(org.apache.log4j.Logger logger) {
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
