package chap14.HashTable.example3.HashTableImplementation;

import java.util.TreeMap;

/**
 * 14-5 实现属于我们自己的哈希表
 *
 * @param <K>
 * @param <V>
 */
public class HashTable<K, V> {

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
        this(97);
    }

    private int hash(K key) {
        // 借助传进来的这个key它对应的hashCode方法转成一个整型,
        // 与上 0x7fffffff 消除负号，真正的转换为这个数组里的索引
        return (key.hashCode() & 0x7fffffff) % M;
    }

    public int getSize() {
        return size;
    }

    public void add(K key, V value) {
        // 根据索引从TreeMap数组中取出 map
        TreeMap<K, V> map = hashtable[hash(key)];
        // map 是否已经包含这个 key
        if (map.containsKey(key))
            map.put(key, value);
        else {
            // 真正的添加
            map.put(key, value);
            size++;
        }
    }

    public V remove(K key) {
        V ret = null;
        TreeMap<K, V> map = hashtable[hash(key)];
        if (map.containsKey(key)) { // 如果包含删除
            ret = map.remove(key);
            size--;
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
}
