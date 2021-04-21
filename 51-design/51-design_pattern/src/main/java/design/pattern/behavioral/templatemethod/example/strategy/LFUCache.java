package design.pattern.behavioral.templatemethod.example.strategy;

import design.pattern.behavioral.templatemethod.example.cache.Cache;
import design.pattern.behavioral.templatemethod.example.cache.CacheObj;

import java.util.Iterator;

/**
 * 最少使用
 * @param <K>
 * @param <V>
 */
public class LFUCache<K, V> extends Cache<K, V> {

	public LFUCache(int capacity, long timeout) {
		super(capacity, timeout);
	}

	@Override
	protected int forcePrune() {
		Iterator<CacheObj<K, V>> iterator = cacheMap.values().iterator();
		long leastAccess = Long.MAX_VALUE;
		CacheObj<K, V> item = null;
		while (iterator.hasNext()) {
			CacheObj<K, V> next = iterator.next();
			if (next.getAccessCount() < leastAccess) {
				item = next;
				leastAccess = next.getAccessCount();
			}
		}
		if (item != null) {
			cacheMap.remove(item.getKey());
			return 1;
		}
		return 0;
	}
}
