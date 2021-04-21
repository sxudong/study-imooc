package design.pattern.creational.singleton.example;

/**
 * 内部类实现单例
 *
 * 【懒汉式】的另外一种实现方式，通过内部类来持有实例对象，当单例类被Load时，
 * 内部类并不会被加载，也就不会创建实例，只有当客户端真正需要访问实例时，内
 * 部类才会被加载并创建实例。
 */
public class SerialGenerator_InnerClass {
	private long code;

	private SerialGenerator_InnerClass() {
	}

	public synchronized long next() {
		return ++code;
	}

	private static class InnerClass {
		final static SerialGenerator_InnerClass INSTANCE = new SerialGenerator_InnerClass();
	}

	public static SerialGenerator_InnerClass getInstance() {
		return InnerClass.INSTANCE;
	}
}
