package chap7.SetAndMap.example1.SetBasicsAndBSTSet;

/**
 * 7-1 集合基础和基于二分搜索树的集合实现
 * @param <E>
 */
public class BSTSet<E extends Comparable<E>> implements Set<E> {

    private BST<E> bst; // 二分搜索树

    public BSTSet(){
        bst = new BST<>();
    }

    @Override
    public int getSize(){
        return bst.size();
    }

    @Override
    public boolean isEmpty(){
        return bst.isEmpty();
    }

    @Override
    public void add(E e){
        bst.add(e);
    }

    @Override
    public boolean contains(E e){
        return bst.contains(e);
    }

    @Override
    public void remove(E e){
        bst.remove(e);
    }
}
