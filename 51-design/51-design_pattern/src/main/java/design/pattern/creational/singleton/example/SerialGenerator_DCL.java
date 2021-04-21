package design.pattern.creational.singleton.example;

/**
 * DCL懒汉式
 *
 * DCL全称是：Double Check Lock，双重检查加锁，是【懒汉式】的一种实现方式。
 * 实例默认不会创建，只有当客户端真正需要访问实例时，实例才会被创建，重点是
 * 控制并发访问。
 */
public class SerialGenerator_DCL {
	private long code;
	private static volatile SerialGenerator_DCL instance;

	public synchronized long next() {
		return ++code;
	}

	public static SerialGenerator_DCL getInstance() {
		if (instance == null) {
			synchronized (SerialGenerator_DCL.class) {
				if (instance == null) {// recheck
					instance = new SerialGenerator_DCL();
				}
			}
		}
		return instance;
	}
}
