package chapter05;

import java.util.Arrays;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 5-21 使用 Condition 实现一个先入先出的有界队列
 *
 * Condition实现生产者消费者
 *   Condition是用来代替传统 Object 中的 wait() 和 notify() 实现线程间的协作，
 *   Condition的 await() 和 signal() 用于处理线程间协作更加安全与高效。
 *   Condition的使用必须在 lock() 与 unlock() 之间使用，且只能通过 lock.newCondition() 获取
 *
 * 其实下面就是 ArrayBlockingQueue 删减版的部分实现
 */
public class BoundedQueue<T> {
    // 缓冲数组
    private Object[] items;
    // 添加的下标，删除的下标和数组当前数量
    private int addIndex, removeIndex, count;
    private Lock lock = new ReentrantLock(); // 非公平独占锁
    private Condition notEmpty = lock.newCondition(); // 未空条件
    private Condition notFull = lock.newCondition(); // 未满条件

    public BoundedQueue(int size) {
        items = new Object[size];
    }

    // 添加一个元素，如果数组满，则添加线程进入等待状态，直到有“空位”
    public void add(T t) throws InterruptedException {
        lock.lock(); //加锁
        try {
            while (count == items.length) { // 满了
                System.out.println("队列已满：" + Arrays.toString(items));
                notFull.await(); // 其他插入线程阻塞起来
            }
            enqueue(t); // 没满就可以入队
        } finally {
            lock.unlock(); //释放锁
        }
    }

    private void enqueue(Object t) {
        items[addIndex] = t; // 没满就可以入队
        System.out.println("新增下标：" + addIndex + " 值：" + items[addIndex]);
        // addIndex     null  1  2  3
        // removeIndex   0
        //如果添加脚标加1等于数组的长度，将添加脚标设置为0
        if (++addIndex == items.length)
            addIndex = 0;
        ++count;
        notEmpty.signal(); // 叫醒remove的线程
        System.out.println("新增：" + Arrays.toString(items));
    }

    // 移除并返回移除元素
    @SuppressWarnings("unchecked")
    public T remove() throws InterruptedException {
        lock.lock(); //加锁
        try {
            //如果队列为0，表示队列空的
            while (count == 0) {
                System.out.println("队列为空：" + Arrays.toString(items));
                notEmpty.await(); // 阻塞其他获取线程
            }
            return dequeue();
        } finally {
            lock.unlock(); //释放锁
        }
    }

    private T dequeue() {
        Object x = items[removeIndex];
        System.out.println("删除下标：" + removeIndex + " 值：" + items[removeIndex]);
        //将第removeIndex元素设置为null
        items[removeIndex] = null;
        //如果removeIndex加1等于数组长度，将removeIndex设置为0
        if (++removeIndex == items.length)
            removeIndex = 0;
        --count;
        notFull.signal(); // 叫醒add的线程
        System.out.println("删除：" + Arrays.toString(items));
        return (T) x;
    }

    public static void main(String[] args) {
        BoundedQueue queue = new BoundedQueue(4);
        new Thread(new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < 100; i++) {
                    try {
                        queue.add(i);
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();

        new Thread(new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < 100; i++) {
                    try {
                        queue.remove();
                        Thread.sleep(3000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }
}
/* Output:
新增下标：0 值：0
新增：[0, null, null, null]
删除下标：0 值：0
删除：[null, null, null, null]
新增下标：1 值：1
新增：[null, 1, null, null]
新增下标：2 值：2
新增：[null, 1, 2, null]
新增下标：3 值：3
新增：[null, 1, 2, 3]
删除下标：1 值：1
删除：[null, null, 2, 3]
新增下标：0 值：4
新增：[4, null, 2, 3]
新增下标：1 值：5
新增：[4, 5, 2, 3]
删除下标：2 值：2
删除：[4, 5, null, 3]
新增下标：2 值：6
新增：[4, 5, 6, 3]
队列已满：[4, 5, 6, 3]
删除下标：3 值：3
删除：[4, 5, 6, null]
新增下标：3 值：7
新增：[4, 5, 6, 7]
队列已满：[4, 5, 6, 7]
删除下标：0 值：4
删除：[null, 5, 6, 7]
新增下标：0 值：8
新增：[8, 5, 6, 7]
队列已满：[8, 5, 6, 7]
 */