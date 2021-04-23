package chap12.AVLTree.example7.MapAndSetInAvlTree;

public interface Map<K, V> {

    void add(K key, V value);
    boolean contains(K key); // 是否包含
    V get(K key);
    void set(K key, V newValue);
    V remove(K key);
    int getSize();
    boolean isEmpty();
}

