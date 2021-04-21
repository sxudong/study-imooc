package design.pattern.behavioral.templatemethod.example.strategy;

import design.pattern.behavioral.templatemethod.example.cache.Cache;
import design.pattern.behavioral.templatemethod.example.cache.CacheObj;

import java.util.Iterator;

/**
 * 最久未使用
 * @param <K>
 * @param <V>
 */
public class LRUCache<K, V> extends Cache<K, V> {

	public LRUCache(int capacity, long timeout) {
		super(capacity, timeout);
	}

	@Override
	protected int forcePrune() {
		Iterator<CacheObj<K, V>> iterator = cacheMap.values().iterator();
		long lastTime = Long.MAX_VALUE;
		CacheObj<K, V> last = null;
		while (iterator.hasNext()) {
			CacheObj<K, V> next = iterator.next();
			if (next.getLastTime() < lastTime) {
				last = next;
				lastTime = next.getLastTime();
			}
		}
		if (last != null) {
			cacheMap.remove(last.getKey());
			return 1;
		}
		return 0;
	}
}
