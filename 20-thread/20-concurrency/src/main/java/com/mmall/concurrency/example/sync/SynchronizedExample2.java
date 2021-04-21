package com.mmall.concurrency.example.sync;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 4-3 原子性 —— Synchronized
 * 修饰静态方法 和 修饰类
 */
@Slf4j
public class SynchronizedExample2 {

    // 修饰一个类
    public static void test1(int j) {
        synchronized (SynchronizedExample2.class) {
            for (int i = 0; i < 10; i++) {
                log.info("test1 {} - {}", j, i);
            }
        }
    }

    // 修饰一个静态方法
    public static synchronized void test2(int j) {
        for (int i = 0; i < 10; i++) {
            log.info("test2 {} - {}", j, i);
        }
    }

    public static void main(String[] args) {
        SynchronizedExample2 example1 = new SynchronizedExample2();
        SynchronizedExample2 example2 = new SynchronizedExample2();
        ExecutorService executorService = Executors.newCachedThreadPool();
        executorService.execute(() -> {
            //example1.test1(1);
            example1.test2(1);
        });
        executorService.execute(() -> {
            //example2.test1(2);
            example2.test2(2);
        });
    }
    /* 静态方法和类 输出一样：
    10:33:33.359 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 0
    10:33:33.366 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 1
    10:33:33.367 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 2
    10:33:33.367 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 3
    10:33:33.367 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 4
    10:33:33.367 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 5
    10:33:33.367 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 6
    10:33:33.367 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 7
    10:33:33.367 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 8
    10:33:33.368 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 1 - 9
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 0
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 1
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 2
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 3
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 4
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 5
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 6
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 7
    10:33:33.368 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 8
    10:33:33.369 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample2 - test1 2 - 9
     */
}
