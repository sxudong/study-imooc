package design.pattern.behavioral.strategy.example.log.impl;


import design.pattern.behavioral.strategy.example.log.Logger;
import org.aspectj.util.FileUtil;

import java.io.File;

// 磁盘文件记录日志
public class FileLogger implements Logger {
	private static final File file = new File(System.getProperty("user.dir"), "system.log");
	@Override
	public void log(String s) {
		FileUtil.writeAsString(file, s);
	}
}