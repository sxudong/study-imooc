package design.pattern.creational.factorymethod.example.log;

public abstract class AbstractLogger implements Logger {
	protected String name;// 日志记录器名称

	public AbstractLogger(String name) {
		this.name = name;
	}
}
