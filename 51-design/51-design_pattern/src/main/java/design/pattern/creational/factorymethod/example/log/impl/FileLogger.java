package design.pattern.creational.factorymethod.example.log.impl;

import cn.hutool.core.io.FileUtil;
import design.pattern.creational.factorymethod.example.log.AbstractLogger;

import java.io.File;

/**
 * 将日志写入磁盘文件
 */
public class FileLogger extends AbstractLogger {
	//F:\code\design_pattern\logs\debug.log
	private File debugLogFile = new File(System.getProperty("user.dir"), "logs/debug.log");
	//F:\code\design_pattern\logs\error.log
	private File errorLogFile = new File(System.getProperty("user.dir"), "logs/error.log");

	public FileLogger(String name) {
		super(name);
	}

	@Override
	public void debug(String message) {
		FileUtil.appendUtf8String(name + " -- " + message, debugLogFile);
	}

	@Override
	public void error(String message) {
		FileUtil.appendUtf8String(name + " -- " + message, errorLogFile);
	}
}
