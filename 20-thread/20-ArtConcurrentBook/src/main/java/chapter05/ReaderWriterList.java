//: concurrency/ReaderWriterList.java
package chapter05;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * 21.9 ReadWriteLock接口
 * 《Java编程思想四》P761
 */
public class ReaderWriterList<T> {
    private ArrayList<T> lockedList;
    // Make the ordering fair: 使规矩公平：
    private ReentrantReadWriteLock lock = new ReentrantReadWriteLock(true); // 创建“读写锁”

    public ReaderWriterList(int size, T initialValue) {
        lockedList = new ArrayList<T>(Collections.nCopies(size, initialValue)); // Collections.nCopies()轻量级集合包装器
    }

    public T set(int index, T element) {
        Lock wlock = lock.writeLock(); // 写锁
        wlock.lock();
        try {
            return lockedList.set(index, element);
        } finally {
            wlock.unlock();
        }
    }

    public T get(int index) {
        Lock rlock = lock.readLock(); // 读锁
        rlock.lock();
        try {
            // Show that multiple readers may acquire the read lock:
            // 显示多个线程读取者可能获得读锁计数：
            if (lock.getReadLockCount() > 1) // 总的读锁计数
                System.out.println("总的读锁计数: " + lock.getReadLockCount());
            return lockedList.get(index);
        } finally {
            rlock.unlock();
        }
    }

    public static void main(String[] args) throws Exception {
        new ReaderWriterListTest(30, 1);
    }
    // 轻量级集合包装器 将返回一个实现了 List 接口的不可修改的对象， 并给人一种包含 n个元素， 每个元素都像是一个 anObject 的错觉。
//    public static void main(String[] args) {
//        List list = Collections.nCopies(5, "tuitorial Point");
//        System.out.println("Values are :");
//        list.forEach(System.out::println);
//    }
}

class ReaderWriterListTest {
    ExecutorService exec = Executors.newCachedThreadPool();
    private final static int SIZE = 100;
    private static Random rand = new Random(47);
    private ReaderWriterList<Integer> list = new ReaderWriterList<Integer>(SIZE, 0);

    /**
     * 写入者任务
     */
    private class Writer implements Runnable {
        @Override
        public void run() {
            try {
                for (int i = 0; i < 20; i++) { // 2 second test
                    list.set(i, rand.nextInt());
                    TimeUnit.MILLISECONDS.sleep(100);
                }
            } catch (InterruptedException e) {
                // Acceptable way to exit 可接受的退出方式
            }
            System.out.println("Writer finished, shutting down");
            exec.shutdownNow();
        }
    }

    /**
     * 读取者任务
     */
    private class Reader implements Runnable {
        @Override
        public void run() {
            try {
                while (!Thread.interrupted()) {
                    for (int i = 0; i < SIZE; i++) {
                        list.get(i);
                        TimeUnit.MILLISECONDS.sleep(1);
                    }
                }
            } catch (InterruptedException e) {
                // Acceptable way to exit 可接受的退出方式
            }
        }
    }

    public ReaderWriterListTest(int readers, int writers) {
        for (int i = 0; i < readers; i++)   //  new ReaderWriterListTest(30, 1);
            exec.execute(new Reader());
        for (int i = 0; i < writers; i++)
            exec.execute(new Writer());
    }
} /* 先执行的读锁，写锁阻塞到最后才获取到同步状态：
总的读锁计数: 3
总的读锁计数: 3
总的读锁计数: 3
总的读锁计数: 2
总的读锁计数: 4
总的读锁计数: 4
总的读锁计数: 6
......
Writer finished, shutting down
*///:~
