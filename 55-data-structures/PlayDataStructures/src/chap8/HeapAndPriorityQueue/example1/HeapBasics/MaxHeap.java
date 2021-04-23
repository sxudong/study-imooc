package chap8.HeapAndPriorityQueue.example1.HeapBasics;

/**
 * 8-2 堆的基础表示
 *
 * 最大堆
 *
 * @param <E>
 */
public class MaxHeap<E extends Comparable<E>> {

    private Array<E> data; // 动态数组

    public MaxHeap(int capacity){
        data = new Array<>(capacity);
    }

    public MaxHeap(){
        data = new Array<>();
    }

    // 返回堆中的元素个数
    public int size(){
        return data.getSize();
    }

    // 返回一个布尔值, 表示堆中是否为空
    public boolean isEmpty(){
        return data.isEmpty();
    }

    /**
     * 私有方法：获取父节点索引
     * @param index 索引
     * @return 返回完全二叉树的数组表示中，一个索引所表示的元素的父亲节点的索引
     */
    private int parent(int index){
        if(index == 0) // 0节点没有父节点
            throw new IllegalArgumentException("index-0 doesn't have parent.");
        return (index - 1) / 2;
    }

    /**
     * 私有方法：获取左孩子节点的索引
     * @param index 索引
     * @return 返回完全二叉树的数组表示中，一个索引所表示的元素的左孩子节点的索引
     */
    private int leftChild(int index){
        return index * 2 + 1;
    }

    /**
     * 私有方法：获取右孩子节点的索引
     * @param index 索引
     * @return 返回完全二叉树的数组表示中，一个索引所表示的元素的右孩子节点的索引
     */
    private int rightChild(int index){
        return index * 2 + 2;
    }
}
