package design.pattern.structural.proxy.example.proxy;

import design.pattern.structural.proxy.example.executor.SqlExecutor;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 现在又有一个新的需求，对于重复的SQL查询，可以将查询结果缓存起来，下次再查询时直接从缓存中获取结果。
 * 又去改SqlExecutor源码？别忘了，那不符合开闭原则，通过代理对象来增强即可。
 */
public class CacheProxy implements SqlExecutor {
	private Map<String, Object> cache = new ConcurrentHashMap<>();
	private SqlExecutor target;

	public CacheProxy(SqlExecutor executor) {
		this.target = executor;
	}

	@Override
	public Object query(String sql) {
		if (cache.containsKey(sql)) {
			System.out.println("命中缓存...");
			return cache.get(sql);
		}
		Object result = target.query(sql);
		cache.put(sql, result);
		return result;
	}

	@Override
	public int update(String sql) {
		System.out.println("缓存失效...");
		cache.clear();
		return target.update(sql);
	}
}
