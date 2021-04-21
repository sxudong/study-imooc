package design.pattern.creational.singleton.example;

/**
 * 单例枚举
 *
 * 枚举的方式可以避免这种破坏，是实现单例的最佳方式
 */
public enum SerialGenerator_Enum {
	INSTANCE;

	private long code;

	public synchronized long next() {
		return ++code;
	}
}
