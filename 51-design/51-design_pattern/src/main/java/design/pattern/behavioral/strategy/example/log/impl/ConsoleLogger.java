package design.pattern.behavioral.strategy.example.log.impl;

import design.pattern.behavioral.strategy.example.log.Logger;

// 单纯的控制台输出日志
public class ConsoleLogger implements Logger {
	@Override
	public void log(String s) {
		System.out.println(s);
	}
}