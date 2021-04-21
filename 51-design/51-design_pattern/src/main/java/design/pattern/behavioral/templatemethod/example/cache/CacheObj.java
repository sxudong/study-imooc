package design.pattern.behavioral.templatemethod.example.cache;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 编写CacheObj，用来包装缓存对象，记录缓存是什么时候产生的，访问了的次数，
 * 最后一次访问是什么时候，这些都是为后期的淘汰算法准备的。
 * @param <K>
 * @param <V>
 */
public class CacheObj<K,V> {
	private final K k;
	private final V v;

	private final long expire;//过期时间
	private AtomicLong accessCount;// 访问次数
	private long createTime;// 生成时间
	private long lastTime;// 最近一次访问时间

	public CacheObj(K k,V v, long expire) {
		this.k = k;
		this.v = v;
		long now = System.nanoTime();
		this.expire = now + TimeUnit.MILLISECONDS.toNanos(expire);
		accessCount = new AtomicLong(0);
		lastTime = createTime = now;
	}

	// 获取缓存对象，如果过期则不返回
	public V get() {
		if (expire - System.nanoTime() < 0) {
			return null;
		}
		accessCount.incrementAndGet();
		lastTime = System.nanoTime();
		return v;
	}

	public K getKey() {
		return k;
	}

	public V getValue() {
		return v;
	}

	// 是否过期
	public boolean isExpired(){
		return System.nanoTime() - expire > 0;
	}

	public long getCreateTime() {
		return createTime;
	}

	public long getLastTime() {
		return lastTime;
	}

	public long getAccessCount() {
		return accessCount.get();
	}
}
