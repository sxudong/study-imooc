package chap14.HashTable.example4.ResizingInHashTable;

import java.util.Map;
import java.util.TreeMap;

/**
 * 14-6 哈希表的动态空间处理与复杂度分析。
 * @param <K>
 * @param <V>
 */
public class HashTable<K, V> {

    // 平均每一个地址哈希冲突元素上界
    private static final int upperTol = 10;
    // 平均每一个地址哈希冲突元素上界
    private static final int lowerTol = 2;
    // 初始哈希容量
    private static final int initCapacity = 7;

    private TreeMap<K, V>[] hashtable;
    private int size;
    private int M;

    public HashTable(int M) {
        this.M = M;
        size = 0;
        hashtable = new TreeMap[M];
        for (int i = 0; i < M; i++)
            hashtable[i] = new TreeMap<>();
    }

    public HashTable() {
        this(initCapacity);
    }

    private int hash(K key) {
        return (key.hashCode() & 0x7fffffff) % M;
    }

    public int getSize() {
        return size;
    }

    public void add(K key, V value) {
        TreeMap<K, V> map = hashtable[hash(key)];
        if (map.containsKey(key))
            map.put(key, value);
        else {
            map.put(key, value);
            size++;
            // 扩容
            // 如果添加元素之后，哈希表中元素总数大于 上界 * 数组容量
            if (size >= upperTol * M)
                // 扩容2倍
                resize(2 * M);
        }
    }

    public V remove(K key) {
        V ret = null;
        TreeMap<K, V> map = hashtable[hash(key)];
        if (map.containsKey(key)) {
            ret = map.remove(key);
            size--;
            // 缩容
            // 如果删除元素之后，哈希表中元素总数比小于 下界 * 数组容量，
            // 边界条件：M / 2 要大于初始容量，这样缩容时最小等初始容量
            if (size < lowerTol * M && M / 2 >= initCapacity)
                resize(M / 2);
        }
        return ret;
    }

    public void set(K key, V value) {
        TreeMap<K, V> map = hashtable[hash(key)];
        if (!map.containsKey(key))
            throw new IllegalArgumentException(key + " doesn't exist!");

        map.put(key, value);
    }

    public boolean contains(K key) {
        return hashtable[hash(key)].containsKey(key);
    }

    public V get(K key) {
        return hashtable[hash(key)].get(key);
    }

    private void resize(int newM) {
        TreeMap<K, V>[] newHashTable = new TreeMap[newM];
        for (int i = 0; i < newM; i++)
            newHashTable[i] = new TreeMap<>();

        int oldM = M;
        this.M = newM;
        for (int i = 0; i < oldM; i++) {
            TreeMap<K, V> map = hashtable[i];
            for (K key : map.keySet())
                newHashTable[hash(key)].put(key, map.get(key));
        }

        this.hashtable = newHashTable;
    }
}
