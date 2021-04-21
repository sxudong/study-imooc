package com.mmall.concurrency.example.lock;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 7-6 ReentrantLock Condition
 */
@Slf4j
public class LockExample6 {

    public static void main(String[] args) {
        ReentrantLock reentrantLock = new ReentrantLock();
        Condition condition = reentrantLock.newCondition();

        new Thread(() -> {
            try {
                reentrantLock.lock();
                log.info("wait signal"); // step 1
                condition.await(); // 加入到condition队列中挂起
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            log.info("get signal"); // step 4
            reentrantLock.unlock();
        }).start();

        new Thread(() -> {
            reentrantLock.lock();
            log.info("get lock"); // step 2
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            condition.signalAll(); // 唤醒所有在这个Condition上被其挂起的任务
            log.info("send signal ~ "); // step 3
            reentrantLock.unlock();
        }).start();
    }
}
/* Output:
  12:02:17.484 [Thread-0] INFO com.mmall.concurrency.example.lock.LockExample6 - wait signal
  12:02:17.487 [Thread-1] INFO com.mmall.concurrency.example.lock.LockExample6 - get lock
  12:02:20.496 [Thread-1] INFO com.mmall.concurrency.example.lock.LockExample6 - send signal ~
  12:02:20.496 [Thread-0] INFO com.mmall.concurrency.example.lock.LockExample6 - get signal
*///:~