package design.pattern.creational.singleton.example;

/**
 * 序列号的实现
 *
 * 如果不是单例，多个生成器实例生成的序列号都是从0开始，会造成冲突，优化如下:
 */
class SerialGenerator{
	private long code;
	private static final SerialGenerator INSTANCE = new SerialGenerator();
	// 私有化构造器，防止外部new
	private SerialGenerator(){}

	public synchronized long next(){
		return ++code;
	}

	public static SerialGenerator getInstance(){
		return INSTANCE;
	}
}
