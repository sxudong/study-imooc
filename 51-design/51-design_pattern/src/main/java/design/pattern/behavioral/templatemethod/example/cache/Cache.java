package design.pattern.behavioral.templatemethod.example.cache;

import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 定义Cache抽象类，定义公共的属性，实现公共逻辑。
 * @param <K>
 * @param <V>
 */
public abstract class Cache<K, V> {
	protected final Map<K, CacheObj<K, V>> cacheMap = new ConcurrentHashMap<>();//容器
	protected int capacity;//容量
	protected long timeout;//过期时间 纳秒

	public Cache(int capacity, long timeout) {
		this.capacity = capacity;
		this.timeout = timeout;
	}

	// 添加元素
	public void put(K k, V v) {
		if (isFull()) {
			// 满了就清理
			prune();
		}
		cacheMap.put(k, new CacheObj<>(k, v, timeout));
	}

	// 获取元素
	public V get(K k) {
		CacheObj<K, V> cacheObj = cacheMap.get(k);
		if (cacheObj == null) {
			return null;
		}
		return cacheObj.get();
	}

	// 容器清理，子类不允许重写
	public final int prune() {
		// 优先清理已过期的
		Iterator<CacheObj<K, V>> iterator = cacheMap.values().iterator();
		int count = 0;
		while (iterator.hasNext()) {
			CacheObj<K, V> next = iterator.next();
			if (next.isExpired()) {
				iterator.remove();
				count++;
			}
		}
		if (isFull()) {
			// 还是满，执行子类强制清除算法
			return count + forcePrune();
		}
		return count;
	}

	// 强制清理，子类实现淘汰策略
	protected abstract int forcePrune();

	// 容器是否满了
	protected boolean isFull() {
		return cacheMap.size() >= capacity;
	}
}
