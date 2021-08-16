package chap12.AVLTree.example7.MapAndSetInAvlTree;

/**
 * 12-8 基于AVL树的集合
 * @param <E>
 */
public class AVLSet<E extends Comparable<E>> implements Set<E> { //实现Set接口

    private AVLTree<E, Object> avl;

    public AVLSet(){
        avl = new AVLTree<>();
    }

    @Override
    public int getSize(){
        return avl.getSize();
    }

    @Override
    public boolean isEmpty(){
        return avl.isEmpty();
    }

    @Override
    public void add(E e){
        avl.add(e, null);
    }

    @Override
    public boolean contains(E e){
        return avl.contains(e);
    }

    @Override
    public void remove(E e){
        avl.remove(e);
    }
}
