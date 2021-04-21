package design.pattern.structural.adapter.example;

import ch.qos.logback.classic.LoggerContext;
import design.pattern.structural.adapter.example.log.Logger;
import design.pattern.structural.adapter.example.log.impl.JdkLoggerAdapter;
import design.pattern.structural.adapter.example.log.impl.Log4jLoggerAdapter;
import design.pattern.structural.adapter.example.log.impl.LogbackLoggerAdapter;


public class LoggerFactory {
	private static LogEnum logEnum;

	public static void setLogEnum(LogEnum logEnum) {
		LoggerFactory.logEnum = logEnum;
	}

	public static Logger getLogger(Class<?> c) {
		switch (logEnum) {
			case JDK:
				return new JdkLoggerAdapter(java.util.logging.Logger.getLogger(c.getName()));
			case LOG4J:
				return new Log4jLoggerAdapter(org.apache.log4j.Logger.getLogger(c));
			case LOGBACK:
				return new LogbackLoggerAdapter(new LoggerContext().getLogger(c));
			default:
				return null;
		}
	}
}
