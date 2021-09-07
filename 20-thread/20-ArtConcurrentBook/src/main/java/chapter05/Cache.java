package chapter05;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * 5-16 通过一个缓存示例说明读写锁的使用方式
 * 5.4.1 读写锁的接口与示例 ReentrantReadWriteLock
 *
 * Cache 使用"读写锁"提升"读操作"的并发性，也保证每次"写操作"
 * 对所有的"读写操作"的可见性，同时简化了编程方式。
 */
public class Cache {
    //非线程安全的 HashMap 作为缓存的实现
    private static final Map<String, Object>    map = new HashMap<String, Object>();
    //使用读写锁的"读锁"和"写锁"来保证 Cache 是线程安全的
    private static final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
    private static final Lock                   r   = rwl.readLock();
    private static final Lock                   w   = rwl.writeLock();

    //在读操作get(String key)方法中，需要获取读锁，这使/得并发访问该方法时不会被阻塞
    public static final Object get(String key) {
        r.lock();
        try {
            return map.get(key);
        } finally {
            r.unlock();
        }
    }

    //写操作 put(String key,Object value) 方法和 clear() 方法，在更新 HashMap 时必须
    //提前获取"写锁"，当获取"写锁"后，其他线程对于"读锁"和"写锁"的获取均被阻塞，而只有
    //"写锁"被释放之后，其他"读写操作"才能继续。
    public static final Object put(String key, Object value) {
        w.lock();
        try {
            return map.put(key, value);
        } finally {
            w.unlock();
        }
    }

    public static final void clear() {
        w.lock();
        try {
            map.clear();
        } finally {
            w.unlock();
        }
    }

    public static void main(String[] args) {
        Cache cache = new Cache();
        cache.put("test", "HelloWorld");
        System.out.println(cache.get("test"));
    }
}
