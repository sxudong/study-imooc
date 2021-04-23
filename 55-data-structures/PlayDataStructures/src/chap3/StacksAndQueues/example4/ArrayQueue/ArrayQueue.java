package chap3.StacksAndQueues.example4.ArrayQueue;

/**
 * 队更 Queue
 * @param <E>
 */
public class ArrayQueue<E> implements Queue<E> {

    private Array<E> array;

    public ArrayQueue(int capacity){
        array = new Array<>(capacity);
    }

    public ArrayQueue(){
        array = new Array<>();
    }

    @Override
    public int getSize(){
        return array.getSize();
    }

    @Override
    public boolean isEmpty(){
        return array.isEmpty();
    }

    public int getCapacity(){
        return array.getCapacity();
    }

    @Override
    public void enqueue(E e){
        array.addLast(e);
    }

    @Override
    public E dequeue(){
        return array.removeFirst();
    }

    @Override
    public E getFront(){
        return array.getFirst();
    }

    @Override
    public String toString(){
        StringBuilder res = new StringBuilder();
        res.append("Queue: ");
        res.append("front ["); // 队首
        for(int i = 0 ; i < array.getSize() ; i ++){
            res.append(array.get(i));
            if(i != array.getSize() - 1) // 判断是否是最后一个元素
                res.append(", ");
        }
        res.append("] tail"); // 队尾
        return res.toString();
    }

    public static void main(String[] args) {

        ArrayQueue<Integer> queue = new ArrayQueue<>();
        for(int i = 0 ; i < 10 ; i ++){
            queue.enqueue(i); // 添加元素
            System.out.println(queue);
            if(i % 3 == 2){
                queue.dequeue(); // 取出一个元素
                System.out.println(queue);
            }
        }
        short j = -4;
        j>>>=1;
        System.out.println(j);
    }
}
/* Output:
Queue: front [0] tail
Queue: front [0, 1] tail
Queue: front [0, 1, 2] tail
Queue: front [1, 2] tail
Queue: front [1, 2, 3] tail
Queue: front [1, 2, 3, 4] tail
Queue: front [1, 2, 3, 4, 5] tail
Queue: front [2, 3, 4, 5] tail
Queue: front [2, 3, 4, 5, 6] tail
Queue: front [2, 3, 4, 5, 6, 7] tail
Queue: front [2, 3, 4, 5, 6, 7, 8] tail
Queue: front [3, 4, 5, 6, 7, 8] tail
Queue: front [3, 4, 5, 6, 7, 8, 9] tail
*///~