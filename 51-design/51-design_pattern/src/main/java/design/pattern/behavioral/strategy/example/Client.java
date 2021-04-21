package design.pattern.behavioral.strategy.example;

import design.pattern.behavioral.strategy.example.log.impl.ConsoleLogger;
import design.pattern.behavioral.strategy.example.log.impl.DbLogger;
import design.pattern.behavioral.strategy.example.log.impl.FileLogger;

/**
 * 策略模式-记录日志的N种方式
 * https://javap.blog.csdn.net/article/details/112318399
 *
 * 场景：维护过线上系统的应该都清楚日志的重要性，它可以帮助我们在系统异常时快速定位到问题，并进行解决。
 *
 * 对于不同的环境，记录日志的方式也是不一样的，这里列举三种情况：
 *   1.开发环境，控制台输出日志即可。
 *   2.线上环境，日志持久化到磁盘文件，方便后期排查问题。
 *   3.日志要做离线分析，需要存入数据库。
 */
public class Client {
	public static void main(String[] args) {
		LogContext logContext = new LogContext();

		logContext.setLogger(new ConsoleLogger());
		logContext.doSomething("console");

		logContext.setLogger(new FileLogger());
		logContext.doSomething("file");

		logContext.setLogger(new DbLogger());
		logContext.doSomething("db"); //这个会报错
	}
}
/* Output:
console
Exception in thread "main" java.lang.NullPointerException
	at design.pattern.behavioral.strategy.example.log.impl.DbLogger.log(DbLogger.java:15)
	at design.pattern.behavioral.strategy.example.LogContext.doSomething(LogContext.java:14)
	at design.pattern.behavioral.strategy.example.Client.main(Client.java:29)
 */