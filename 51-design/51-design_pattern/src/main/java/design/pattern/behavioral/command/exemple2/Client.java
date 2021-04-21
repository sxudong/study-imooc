package design.pattern.behavioral.command.exemple2;

import design.pattern.behavioral.command.exemple2.command.impl.PublishCommand;
import design.pattern.behavioral.command.exemple2.command.impl.UpdateCommand;

/**
 * 命令模式-文章发布背后的秘密
 * https://javap.blog.csdn.net/article/details/112038036
 * 博客系统
 * 用户发布一篇文章，系统需要完成三个主要动作：
 *   1.文章数据保存到数据库。
 *   2.文章内容进行中文分词，建立全文索引存储到 ElasticSearch。
 *   3.Redis设置BitMap，用作布尔过滤器，防止缓存穿透。
 */
public class Client {
	//客户端想发布文章时，这样调用
	public static void main(String[] args) {
		Invoker invoker = new Invoker();
		invoker.setCommand(new PublishCommand());
		invoker.action();

		// 客户端只需要创建UpdateCommand交给Invoker执行就好了，
		// 其他地方都不用动，非常方便。
		invoker.setCommand(new UpdateCommand());
		invoker.action();
	}
}
/* Output:
文章保存到数据库...
ElasticSearch建立文章索引...
设置位图...
文章保存到数据库...
ElasticSearch更新文章索引...
 */