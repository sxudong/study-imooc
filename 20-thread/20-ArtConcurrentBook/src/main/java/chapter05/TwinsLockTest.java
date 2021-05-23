package chapter05;

import java.util.concurrent.locks.Lock;

import chapter04.SleepUtils;

/**
 * 代码清单5-11
 *
 * 测试来验证 TwinsLock 是否能按照预期工作。在测试用例中，定义了工作者线程 Worker，
 * 该线程在执行过程中获取锁，当获取锁之后使当前线程睡眠1秒（并不释放锁），随后打
 * 印当前线程名称，最后再次睡眠1秒并释放锁.
 */
public class TwinsLockTest {
    public static void main(String[] args) {
        TwinsLockTest lockTest = new TwinsLockTest();
        lockTest.test();
    }

    public void test() {
        final Lock lock = new TwinsLock();
        class Worker extends Thread {
            @Override
            public void run() {
                while (true) {
                    lock.lock();
                    try {
                        SleepUtils.second(1);
                        System.out.println(Thread.currentThread().getName());
                        SleepUtils.second(1);
                    } finally {
                        lock.unlock();
                    }
                }
            }
        }
        // 启动10个线程
        for (int i = 0; i < 10; i++) {
            Worker w = new Worker();
            w.setDaemon(true); //设置为后台守护线程
            w.start();
        }
        // 每隔1秒换行
        for (int i = 0; i < 10; i++) {
            SleepUtils.second(1);
            System.out.println();
        }
    }
}
/* 运行该测试用例，可以看到线程名称成对输出，也就是在同一时刻只
 * 有两个线程能够获取到锁，这表明TwinsLock可以按照预期正确工作:
Thread-1
Thread-0


Thread-1
Thread-0


Thread-1
Thread-0



Thread-0
Thread-1


Thread-1
Thread-0

 */