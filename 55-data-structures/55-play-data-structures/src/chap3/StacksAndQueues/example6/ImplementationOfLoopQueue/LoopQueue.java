package chap3.StacksAndQueues.example6.ImplementationOfLoopQueue;

public class LoopQueue<E> implements Queue<E> {

    private E[] data;
    private int front, tail;
    private int size;  // 有兴趣的同学，在完成这一章后，可以思考一下：
                       // LoopQueue中不声明size，如何完成所有的逻辑？
                       // 这个问题可能会比大家想象的要难一点点：）

    public LoopQueue(int capacity){
        data = (E[])new Object[capacity + 1];
        front = 0;
        tail = 0;
        size = 0;
    }

    public LoopQueue(){
        this(10);
    }

    public int getCapacity(){
        return data.length - 1;
    }

    @Override
    public boolean isEmpty(){
        return front == tail;
    }

    @Override
    public int getSize(){
        return size;
    }

    //入队操作（重点部分）
    @Override
    public void enqueue(E e){

        // 扩容
        if((tail + 1) % data.length == front)
            resize(getCapacity() * 2);

        data[tail] = e;
        tail = (tail + 1) % data.length;
        size ++;
    }

    //出队操作（重点部分）
    @Override
    public E dequeue(){
        if(isEmpty())
            throw new IllegalArgumentException("Cannot dequeue from an empty queue.");

        E ret = data[front];
        data[front] = null;
        front = (front + 1) % data.length; //人队首除出，所以新的队首加1
        size --;
        // 缩容
        if(size == getCapacity() / 4 && getCapacity() / 2 != 0)
            resize(getCapacity() / 2);
        return ret;
    }

    @Override
    public E getFront(){
        if(isEmpty())
            throw new IllegalArgumentException("Queue is empty.");
        return data[front];
    }

    // resize这里也改变了，多看几遍自行体会
    private void resize(int newCapacity){
        E[] newData = (E[]) new Object[newCapacity + 1];
        for(int i = 0 ; i < size ; i ++)
            // 从原来队列的队首开始放入
            // 如果队首front = “3 + 0”,依次“3 + 1”、“3 + 2”
            // 防止越界 求余 data.length
            newData[i] = data[(front + i) % data.length];

        data = newData;
        front = 0;
        tail = size;
    }

    @Override
    public String toString(){

        StringBuilder res = new StringBuilder();
        res.append(String.format("Queue: size = %d , capacity = %d\n", size, getCapacity()));
        res.append("front [");
        // 第一个位置在front, i等于front，不能等于tail，每次加1
        for(int i = front ; i != tail ; i = (i + 1) % data.length){
            res.append(data[i]);
            if((i + 1) % data.length != tail) // 如果不是最后一个元素
                res.append(", ");
        }
        res.append("] tail");
        return res.toString();
    }

    public static void main(String[] args){

        LoopQueue<Integer> queue = new LoopQueue<>();
        for(int i = 0 ; i < 10 ; i ++){
            queue.enqueue(i);
            System.out.println(queue);

            if(i % 3 == 2){
                queue.dequeue();
                System.out.println(queue);
            }
        }
    }
}
/* Output:
Queue: size = 1 , capacity = 10
front [0] tail
Queue: size = 2 , capacity = 10
front [0, 1] tail
Queue: size = 3 , capacity = 10
front [0, 1, 2] tail
Queue: size = 2 , capacity = 5
front [1, 2] tail
Queue: size = 3 , capacity = 5
front [1, 2, 3] tail
Queue: size = 4 , capacity = 5
front [1, 2, 3, 4] tail
Queue: size = 5 , capacity = 5
front [1, 2, 3, 4, 5] tail
Queue: size = 4 , capacity = 5
front [2, 3, 4, 5] tail
Queue: size = 5 , capacity = 5
front [2, 3, 4, 5, 6] tail
Queue: size = 6 , capacity = 10
front [2, 3, 4, 5, 6, 7] tail
Queue: size = 7 , capacity = 10
front [2, 3, 4, 5, 6, 7, 8] tail
Queue: size = 6 , capacity = 10
front [3, 4, 5, 6, 7, 8] tail
Queue: size = 7 , capacity = 10
front [3, 4, 5, 6, 7, 8, 9] tail
*///~