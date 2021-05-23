package chapter05;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * 5-19 锁降级
 * 因为数据不常变化，所以多个线程可以并发地进行数据处理，当数据变更后，
 * 如果当前线程感知到数据变化，则进行数据的准备工作，同时其他处理线程
 * 被阻塞，直到当前线程完成数据的准备工作。
 */
public class ProcessData {
    private static final ReentrantReadWriteLock rwl       = new ReentrantReadWriteLock();
    private static final Lock                   readLock  = rwl.readLock();
    private static final Lock                   writeLock = rwl.writeLock();
    private volatile boolean                    update    = false;

    public void processData() {
        readLock.lock();  // update变量被设置为false，他线程会被阻塞在“读锁”的lock()方法上
        if (!update) {
            // 必须先释放读锁
            readLock.unlock();
            // 锁降级从写锁获取到开始
            writeLock.lock(); // update变量被设置为false，他线程会被阻塞在“写锁”的lock()方法上
            try {
                if (!update) {
                    // 准备数据的流程（略）
                    update = true;
                }
                readLock.lock();
            } finally {
                writeLock.unlock();
            }
            // 锁降级完成，写锁降级为读锁
        }
        try {
            // 使用数据的流程（略）
        } finally {
            readLock.unlock();
        }
    }
}
/*
 *上述示例中，当数据发生变更后，update变量（布尔类型且volatile修饰）被设置为false，此
 * 时所有访问processData()方法的线程都能够感知到变化，但只有一个线程能够获取到写锁，其
 * 他线程会被阻塞在读锁和写锁的lock()方法上。当前线程获取写锁完成数据准备之后，再获取
 * 读锁，随后释放写锁，完成锁降级。
 *
 */