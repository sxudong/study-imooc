package chap8.HeapAndPriorityQueue.example5.PriorityQueue;

public interface Queue<E> {
    int getSize();
    boolean isEmpty();
    void enqueue(E e);  // 加入一个元素叫“入队”
    E dequeue();        // 取出一个元素叫“出队”
    E getFront();       // 看一下“队首”的元素是谁
}
