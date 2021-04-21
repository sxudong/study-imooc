package design.pattern.structural.proxy.example;

import design.pattern.structural.proxy.example.executor.SqlExecutor;
import design.pattern.structural.proxy.example.executor.impl.MySqlExecutor;
import design.pattern.structural.proxy.example.proxy.CacheProxy;
import design.pattern.structural.proxy.example.proxy.LogProxy;

/**
 * 代理模式-MySql代理
 * https://javap.blog.csdn.net/article/details/111936455
 * 需求：假设现有一个SQL语句执行器，它支持两种操作：查询 和 写入
 */
public class Client {
	public static void main(String[] args) {
		// 支持日志
		SqlExecutor log = new LogProxy(new MySqlExecutor());
		// 支持缓存
		SqlExecutor cache = new CacheProxy(new MySqlExecutor());
		// 缓存+日志
		SqlExecutor logAndCache = new CacheProxy(new LogProxy(new MySqlExecutor()));

		logAndCache.query("select * from user where id = 1");
		logAndCache.query("select * from user where id = 1");
		logAndCache.update("update user set name = 'admin' where id = 1");
	}
}
/*
查询sql:select * from user where id = 1
命中缓存...
缓存失效...
修改sql:update user set name = 'admin' where id = 1
*/