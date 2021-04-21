package design.pattern.structural.proxy.example.executor;

public interface SqlExecutor {

	// 读操作
	Object query(String sql);

	// 写操作
	int update(String sql);
}