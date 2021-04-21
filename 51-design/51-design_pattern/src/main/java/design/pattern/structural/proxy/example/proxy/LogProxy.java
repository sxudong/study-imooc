package design.pattern.structural.proxy.example.proxy;

import design.pattern.structural.proxy.example.executor.SqlExecutor;

/**
 * 现在有一个新的需求，需要将 SqlExecutor 执行的 SQL 语句输出到控制台，以便调试。
 * 你要怎么做？直接修改 MySqlExecutor 吗？这不符合开闭原则。
 *
 * 正确的做法应该是创建一个代理类 LogProxy，由它来完成 SQL 语句的输出。
 */
public class LogProxy implements SqlExecutor {
	private SqlExecutor target;
	public LogProxy(SqlExecutor executor) {
		this.target = executor;
	}

	@Override
	public Object query(String sql) {
		System.out.println("查询sql:" + sql);
		return target.query(sql);
	}

	@Override
	public int update(String sql) {
		System.out.println("修改sql:" + sql);
		return target.update(sql);
	}
}
