package chapter05;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * 5-16 ͨ��һ������ʾ��˵����д����ʹ�÷�ʽ
 * 5.4.1 ��д���Ľӿ���ʾ�� ReentrantReadWriteLock
 *
 * Cache ʹ��"��д��"����"������"�Ĳ����ԣ�Ҳ��֤ÿ��"д����"
 * �����е�"��д����"�Ŀɼ��ԣ�ͬʱ���˱�̷�ʽ��
 */
public class Cache {
    //���̰߳�ȫ�� HashMap ��Ϊ�����ʵ��
    private static final Map<String, Object>    map = new HashMap<String, Object>();
    //ʹ�ö�д����"����"��"д��"����֤ Cache ���̰߳�ȫ��
    private static final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
    private static final Lock                   r   = rwl.readLock();
    private static final Lock                   w   = rwl.writeLock();

    //�ڶ�����get(String key)�����У���Ҫ��ȡ��������ʹ/�ò������ʸ÷���ʱ���ᱻ����
    public static final Object get(String key) {
        r.lock();
        try {
            return map.get(key);
        } finally {
            r.unlock();
        }
    }

    //д���� put(String key,Object value) ������ clear() �������ڸ��� HashMap ʱ����
    //��ǰ��ȡ"д��"������ȡ"д��"�������̶߳���"����"��"д��"�Ļ�ȡ������������ֻ��
    //"д��"���ͷ�֮������"��д����"���ܼ�����
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
