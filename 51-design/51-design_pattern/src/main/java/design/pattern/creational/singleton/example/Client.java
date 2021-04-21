package design.pattern.creational.singleton.example;

/**
 * 单例模式-序列号生成器
 * https://javap.blog.csdn.net/article/details/111601001
 *
 * 设计一个全局的序列号生成器，返回long类型，要求生成的序列号全局唯一且递增。
 */
public class Client {
	public static void main(String[] args) {
		// 客户端调用
		SerialGenerator serialGenerator = SerialGenerator.getInstance();
		serialGenerator.next();
	}
}
