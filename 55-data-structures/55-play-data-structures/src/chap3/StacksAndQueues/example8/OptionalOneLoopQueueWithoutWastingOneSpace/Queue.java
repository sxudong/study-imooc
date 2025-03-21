package chap3.StacksAndQueues.example8.OptionalOneLoopQueueWithoutWastingOneSpace;

public interface Queue<E> {

    int getSize();
    boolean isEmpty();
    void enqueue(E e);
    E dequeue();
    E getFront();
}
