package design.pattern.structural.flyweight.example1;

import design.pattern.structural.flyweight.example1.user.UserService;

/**
 * 享元模式-内存溢出，谁的锅？
 * https://javap.blog.csdn.net/article/details/112549270
 *
 * UserService类稍作修改，原先调用AuthService获取权限列表，现在改为从AuthFactory的缓存中获取，这里就不贴重复代码了。
 * 客户端的调用也没变，但是优化后的代码，内存占用极少，没有再出现内存溢出的情况了，客户非常满意。
 *
 * 1Byte(字节) = 8bit(位) 1KB = 1024Byte(字节) 1MB = 1024KB
 */
public class Client {
	public static void main(String[] args) throws InterruptedException {
		UserService userService = new UserService();
		// 模拟客户端一百万次登陆请求
		for (int i = 0; i < 1000000; i++) {
			userService.login("root", "123");
		}
		showMemory();
	}

	public static void showMemory() {
		Runtime.getRuntime().gc();
		long used = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
		System.out.println("使用内存 = " + used +" 字节");
		//非共享使用内存：397823448 字节 379M
		//共享使用内存：209824248 字节 209M
	}
}