package design.pattern.creational.prototype.example;

import lombok.Setter;

/**
 * 邮件类
 */
@Setter
public class Mail implements Cloneable{
	private String target;//目标邮箱
	private String content;//邮件内容
	private String tail;//落款

	public void send(){
		System.out.println("target:" + target + ",content:" + content);
	}

	/**
	 * clone()是从一个已有的对象中克隆出来的新对象，因此不存在线程安全问题，
	 * 且会保留已有对象的所有属性，而且因为是基于内存的直接拷贝，构造函数不
	 * 会执行，性能上也会比使用new关键字直接创建会好一些。
	 */
	@Override
	protected Mail clone(){
		try {
			return (Mail) super.clone();
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
			return null;
		}
	}
}
