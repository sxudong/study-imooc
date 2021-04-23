package chap12.AVLTree.example7.MapAndSetInAvlTree;

public interface Set<E> {

    void add(E e);
    boolean contains(E e);
    void remove(E e);
    int getSize();
    boolean isEmpty();
}
