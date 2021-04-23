package chap7.SetAndMap.example1.SetBasicsAndBSTSet;

public interface Set<E> {

    void add(E e);        // 添加元素
    boolean contains(E e);// 判断是否包含某个元素
    void remove(E e);     // 删除元素
    int getSize();
    boolean isEmpty();
}
