package design.pattern.structural.adapter.example.log;

public interface Logger {

	void trace(String message);

	void debug(String message);

	void info(String message);

	void warn(String message);

	void error(String message, Throwable t);
}
