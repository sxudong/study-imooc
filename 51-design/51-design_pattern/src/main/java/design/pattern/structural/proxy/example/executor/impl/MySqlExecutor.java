package design.pattern.structural.proxy.example.executor.impl;

import design.pattern.structural.proxy.example.executor.SqlExecutor;

public class MySqlExecutor implements SqlExecutor {

	@Override
	public Object query(String sql) {
		// 查询DB...
		return new Object();
	}

	@Override
	public int update(String sql) {
		// 修改DB...
		return 1;
	}
}