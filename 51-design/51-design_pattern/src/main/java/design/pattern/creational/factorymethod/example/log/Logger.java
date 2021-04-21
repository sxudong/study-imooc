package design.pattern.creational.factorymethod.example.log;

/**
 * 将日志的功能抽象出来，封装成接口：
 */
public interface Logger {

	// 调试信息
	void debug(String message);

	// 错误信息
	void error(String message);
}
