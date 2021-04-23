package chap7.SetAndMap.example3.TimeComplexityOfSet;

public interface Set<E> {

    void add(E e);
    boolean contains(E e);
    void remove(E e);
    int getSize();
    boolean isEmpty();
}
