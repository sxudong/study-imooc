package design.pattern.behavioral.templatemethod.example.strategy;

import design.pattern.behavioral.templatemethod.example.cache.Cache;
import design.pattern.behavioral.templatemethod.example.cache.CacheObj;

import java.util.Iterator;

/**
 * 先进先出
 * @param <K>
 * @param <V>
 */
public class FIFOCache<K,V> extends Cache<K,V> {

	public FIFOCache(int capacity, long timeout) {
		super(capacity, timeout);
	}

	@Override
	protected int forcePrune() {
		Iterator<CacheObj<K, V>> iterator = cacheMap.values().iterator();
		long firstTime = Long.MAX_VALUE;
		CacheObj<K, V> first = null;
		while (iterator.hasNext()) {
			CacheObj<K, V> next = iterator.next();
			if (next.getCreateTime() < firstTime) {
				first = next;
				firstTime = next.getCreateTime();
			}
		}
		if (first != null) {
			cacheMap.remove(first.getKey());
			return 1;
		}
		return 0;
	}
}
