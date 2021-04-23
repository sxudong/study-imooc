package chap7.SetAndMap.example5.MapBasics;

/**
 * 7-5 映射基础
 * @param <K>
 * @param <V>
 */
public interface Map<K, V> {

    void add(K key, V value);
    V remove(K key);
    boolean contains(K key); // 是否包含
    V get(K key);
    void set(K key, V newValue);
    int getSize();
    boolean isEmpty();
}
