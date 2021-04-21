package design.pattern.structural.adapter.example;

import design.pattern.structural.adapter.example.log.Logger;

/**
 * 适配器模式-日志适配器
 * https://javap.blog.csdn.net/article/details/112382904
 * 场景：在系统开发中记录日志的时候，有没有考虑过这样一个问题：万一使用的日志框架要更换呢？
 *      在系统设计之初，开发者就需要考虑到这一点：封装日志抽象，为第三方日志框架做适配。
 *      防止日后更换日志框架时带来的灾难。
 *      我不管第三方日志框架是如何实现的，我只需要定义我们系统日志需要具备哪些功能即可，
 *      如果要引入三方库，就把它适配成我们系统需要的。
 *      事实上，SLF4J就是这么做的，它本身并不提供日志功能，它是一个「简单日志门面」，只
 *      是将三方库适配成了它定义的日志接口。本篇不会讨论SLF4J的实现。
 *
 * 需求：现在假设系统可能需要三种日志实现：JDK日志、Log4j、Logback
 */
public class Client {
	public static void main(String[] args) throws Exception {
		LoggerFactory.setLogEnum(LogEnum.JDK);
		Logger logger = LoggerFactory.getLogger(Client.class);
		logger.info("JDK 日志...");
	}
}
/* Output:
三月 27, 2021 11:04:01 上午 design.pattern.structural.adapter.example.log.impl.JdkLoggerAdapter info
信息: JDK 日志...
 */