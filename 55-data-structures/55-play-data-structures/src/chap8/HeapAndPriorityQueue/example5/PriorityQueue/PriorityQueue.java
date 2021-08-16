package chap8.HeapAndPriorityQueue.example5.PriorityQueue;

/**
 * 8-6 基于堆的优先队列
 * @param <E>
 */
public class PriorityQueue<E extends Comparable<E>> implements Queue<E> {

    //使用最小堆逻辑进行选择时，每次将最小的删除；
    //如果使用最大堆，需要设定好优先级，如此最大最小就是相对的了。
    private MaxHeap<E> maxHeap; // 最大堆结构

    public PriorityQueue(){
        maxHeap = new MaxHeap<>();
    }

    @Override
    public int getSize(){
        return maxHeap.size();
    }

    @Override
    public boolean isEmpty(){
        return maxHeap.isEmpty();
    }

    @Override
    public E getFront(){
        return maxHeap.findMax();
    }

    // 加入一个元素叫“入队”
    @Override
    public void enqueue(E e){
        maxHeap.add(e);
    }

    // 取出一个元素叫“出队”
    @Override
    public E dequeue(){
        return maxHeap.extractMax();
    }
}
