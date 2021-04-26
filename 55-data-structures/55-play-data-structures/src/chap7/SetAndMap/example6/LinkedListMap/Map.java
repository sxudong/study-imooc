package chap7.SetAndMap.example6.LinkedListMap;

public interface Map<K, V> {

    void add(K key, V value);
    V remove(K key);
    boolean contains(K key); // 是否包含
    V get(K key);
    void set(K key, V newValue);
    int getSize();
    boolean isEmpty();
}
