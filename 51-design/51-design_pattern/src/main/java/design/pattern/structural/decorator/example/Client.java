package design.pattern.structural.decorator.example;

import java.io.IOException;

/**
 * 装饰者模式-包装线程不安全的类
 * https://javap.blog.csdn.net/article/details/112301657
 *
 * 场景：平常使用的大部分容器都是线程不安全的，例如ArrayList、HashMap等，
 *       如果涉及到对容器的并发访问，开发者需要做好同步控制，否则程序会出现异常。
 */
public class Client {
	public static void main(String[] args) throws IOException {
		//List list = new ArrayList();
		// 装饰原ArrayList对象
		List list = new SynchronizedList(new ArrayList());
		list.add(1);
		list.add(2);
		list.add(3);
		System.out.println(list);

		for (int i = 0; i < 10; i++) {
			new Thread(()->{
				for (int k = 0; k < 1000; k++) {
					list.add(k);
				}
			}).start();
		}
	}
}
/*
Exception in thread "Thread-0" Exception in thread "Thread-1" Exception in thread "Thread-3" Exception in thread "Thread-4" java.lang.ArrayIndexOutOfBoundsException: 2048
	at top.javap.dp.unit11.decorator.ArrayList.add(ArrayList.java:19)
	at top.javap.dp.unit11.decorator.Client.lambda$main$0(Client.java:16)
	at java.lang.Thread.run(Thread.java:748)
......
*/