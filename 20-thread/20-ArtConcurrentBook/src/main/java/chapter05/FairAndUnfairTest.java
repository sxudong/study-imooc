package chapter05;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 5-15 公平锁和非公平锁的测试
 *
 * 测试用例：观察公平和非公平锁在获取锁时的区别，在测试用例中定义了内部类
 * ReentrantLock2，公开了 getQueuedThreads() 方法，该方法返回正在等待
 * 获取锁的线程列表，由于列表是逆序输出，为了方便观察结果，将其进行反转。
 */
public class FairAndUnfairTest {

    private static Lock           fairLock   = new ReentrantLock2(true);
    private static Lock           unfairLock = new ReentrantLock2(false);
    private static CountDownLatch start;

    public void fair() {
        testLock(fairLock);
    }

    public void unfair() {
        testLock(unfairLock);
    }

    private void testLock(Lock lock) {
        start = new CountDownLatch(1);
        for (int i = 0; i < 5; i++) {
            Thread thread = new Job(lock);
            thread.setName("" + i);
            thread.start();
        }
        start.countDown();
    }

    private static class Job extends Thread {
        private Lock lock;

        public Job(Lock lock) {
            this.lock = lock;
        }

        // 连续2次打印当前的Thread和等待队列中的Thread
        @Override
        public void run() {
            try {
                start.await();
            } catch (InterruptedException e) {
            }
            for (int i = 0; i < 2; i++) {
                lock.lock();
                try {
                    System.out.println("Lock by [" + getName() + "], Waiting by " + ((ReentrantLock2) lock).getQueuedThreads());
                } finally {
                    lock.unlock();
                }
            }
        }

        public String toString() {
            return getName();
        }
    }

    private static class ReentrantLock2 extends ReentrantLock {
        private static final long serialVersionUID = -6736727496956351588L;

        public ReentrantLock2(boolean fair) {
            super(fair);
        }

        public Collection<Thread> getQueuedThreads() {
            List<Thread> arrayList = new ArrayList<Thread>(super.getQueuedThreads());
            Collections.reverse(arrayList);
            return arrayList;
        }
    }

    public static void main(String[] args) {
        FairAndUnfairTest test = new FairAndUnfairTest();
        test.fair();
        System.out.println("**************");
        //test.unfair();
    }
}
/* 观察结果（其中每个数字代表一个线程）
 *  - 公平性锁每次都是从同步队列中的第一个节点获取到锁。
 *  - 而非公平性锁出现了一个线程连续获取锁的情况。
公平锁的输出：
Lock by [0], Waiting by []
Lock by [1], Waiting by [2, 0]
Lock by [2], Waiting by [0, 1]
Lock by [0], Waiting by [1, 2]
Lock by [1], Waiting by [2]
Lock by [2], Waiting by []
Lock by [3], Waiting by []
Lock by [3], Waiting by []
Lock by [4], Waiting by []
Lock by [4], Waiting by []

非公平锁的输出：
Lock by [0], Waiting by [1]
Lock by [1], Waiting by []
Lock by [1], Waiting by [2, 0]
Lock by [2], Waiting by [0]
Lock by [2], Waiting by [0, 3]
Lock by [0], Waiting by [3]
Lock by [3], Waiting by []
Lock by [3], Waiting by []
Lock by [4], Waiting by []
Lock by [4], Waiting by []
 */