package chap3.StacksAndQueues.example9.OptionalTwoLoopQueueWithoutWastingOneSpace;

public interface Queue<E> {

    int getSize();
    boolean isEmpty();
    void enqueue(E e);
    E dequeue();
    E getFront();
}
