package chapter05;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 5-15 ��ƽ���ͷǹ�ƽ���Ĳ���
 *
 * �����������۲칫ƽ�ͷǹ�ƽ���ڻ�ȡ��ʱ�������ڲ��������ж������ڲ���
 * ReentrantLock2�������� getQueuedThreads() �������÷����������ڵȴ�
 * ��ȡ�����߳��б������б������������Ϊ�˷���۲�����������з�ת��
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

        // ����2�δ�ӡ��ǰ��Thread�͵ȴ������е�Thread
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
/* �۲���������ÿ�����ִ���һ���̣߳�
 *  - ��ƽ����ÿ�ζ��Ǵ�ͬ�������еĵ�һ���ڵ��ȡ������
 *  - ���ǹ�ƽ����������һ���߳�������ȡ���������
��ƽ���������
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

�ǹ�ƽ���������
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