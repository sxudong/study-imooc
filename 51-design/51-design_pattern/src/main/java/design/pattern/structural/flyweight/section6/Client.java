package design.pattern.structural.flyweight.section6;

/**
 * 没有覆盖 equals方法和hashCode方法，使用Java基本类型String作为标志
 */
public class Client {
	public static void main(String[] args) {
		String key1 = "科目1上海";
		String key2 = "科目1上海";
		//初始化对象池
		SignInfoFactory.getSignInfo(key1);

		//计算执行100万次需要的时间
		long currentTime = System.currentTimeMillis();
		for(int i=0;i<1_000_000;i++){
			SignInfoFactory.getSignInfo(key2);
		}
		long tailTime = System.currentTimeMillis();
		
		System.out.println("执行时间："+(tailTime - currentTime) + " ms");
	}
} // 执行时间：21 ms
