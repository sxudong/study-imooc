package design.pattern.creational.prototype.example;

/**
 * 原型模式-广告邮件推送
 * https://javap.blog.csdn.net/article/details/111937724
 *
 * 场景：大部分系统都有「发送邮件」的功能，系统可以通过邮件的方式给客户
 * 发送一些通知、消息提醒、广告推送的邮件。
 */
public class Client {
	public static void main(String[] args) {
		Mail mail = new Mail();
		// 广告的内容都是一样的，一般都是从数据库查询获得
		mail.setContent("AirPods Pro发布，主动降噪，声声入耳更沉浸。");
		// 落款也都是一样的
		mail.setTail("Apple");
		// 开启16个线程并发推送
		for (int i = 0; i < 16; i++) {
			new Thread(()->{
				for (int j = 0; j < 1000; j++) {
					// 从基础对象中克隆出一个新的对象
					Mail clone = mail.clone();
					clone.setTarget(j + "@qq.com");
					clone.send();
				}
			}).start();
		}
	}
}
