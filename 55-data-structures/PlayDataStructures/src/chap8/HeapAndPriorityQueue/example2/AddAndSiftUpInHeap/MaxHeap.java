package chap8.HeapAndPriorityQueue.example2.AddAndSiftUpInHeap;

/**
 * 8-3 向堆中添加元素和Sift Up
 * @param <E>
 */
public class MaxHeap<E extends Comparable<E>> {

    private Array<E> data;

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

    // 返回完全二叉树的数组表示中，一个索引所表示的元素的父亲节点的索引
    private int parent(int index){
        if(index == 0)
            throw new IllegalArgumentException("index-0 doesn't have parent.");
        return (index - 1) / 2;
    }

    // 返回完全二叉树的数组表示中，一个索引所表示的元素的左孩子节点的索引
    private int leftChild(int index){
        return index * 2 + 1;
    }

    // 返回完全二叉树的数组表示中，一个索引所表示的元素的右孩子节点的索引
    private int rightChild(int index){
        return index * 2 + 2;
    }

    // 向堆中添加元素
    public void add(E e){
        data.addLast(e);
        siftUp(data.getSize() - 1);
    }

    /**
     * 上浮
     * @param k 索引
     */
    private void siftUp(int k){
        // 当前k的父节点小于当前k,交换索引位置
        while(k > 0 && data.get(parent(k)).compareTo(data.get(k)) < 0 ) {
            // 交换索引位置
            data.swap(k, parent(k));
            // 当前k已经来到新的位置，进入while循环
            // 它是不是依然不满足堆的性质？
            k = parent(k);
        }
    }
}
