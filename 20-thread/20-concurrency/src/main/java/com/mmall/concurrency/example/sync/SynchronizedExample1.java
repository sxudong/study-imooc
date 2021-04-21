package com.mmall.concurrency.example.sync;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 4-3 原子性 —— Synchronized
 * 修饰代码块 和 修饰方法
 */
//@Slf4j
//public class SynchronizedExample1 {
//
//    // 修饰一个代码块
//    public void test1() {
//        synchronized (this) {
//            for (int i = 0; i < 10; i++) {
//                log.info("test1 {} - {}", i);
//            }
//        }
//    }
//
//    // 修饰一个方法（关键字放在方法上，作用范围在整个方法，称作为同步方法）
//    public synchronized void test2() {
//        for (int i = 0; i < 10; i++) {
//            log.info("test2 {} - {}", i);
//        }
//    }
//
//    public static void main(String[] args) {
//        SynchronizedExample1 example1 = new SynchronizedExample1();
//        ExecutorService executorService = Executors.newCachedThreadPool();
//        // 开启两个进程，同时调用代码块
//        executorService.execute(() -> {
//            example1.test1();
//        });
//        executorService.execute(() -> {
//            example1.test1();
//        });
//    } /* 输出：
//    09:43:32.178 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 0 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 3 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 4 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 5 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 6 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 7 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 8 - {}
//    09:43:32.183 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 9 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 0 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 3 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 4 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 5 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 6 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 7 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 8 - {}
//    09:43:32.184 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 9 - {}
//    */
//}

@Slf4j
public class SynchronizedExample1 {

    // 修饰一个代码块
    public void test1(int j) {
        synchronized (this) {
            for (int i = 0; i < 10; i++) {
                log.info("test1 {} - {}", j, i);
            }
        }
    }

    // 修饰一个方法（关键字放在方法上，作用范围在整个方法，称作为同步方法）
    public synchronized void test2(int j) {
        for (int i = 0; i < 10; i++) {
            log.info("test2 {} - {}", j, i);
        }
    }

    public static void main(String[] args) {
        SynchronizedExample1 example1 = new SynchronizedExample1();
        SynchronizedExample1 example2 = new SynchronizedExample1();
        ExecutorService executorService = Executors.newCachedThreadPool();

        executorService.execute(() -> {
            example1.test1(1);
            //example1.test2(1);
        });
        executorService.execute(() -> {
            example2.test1(2);
            //example2.test2(2);
        });
    }
    /* 交替执行
    10:01:35.607 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 0
    10:01:35.612 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 1
    10:01:35.612 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 2
    10:01:35.612 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 3
    10:01:35.612 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 4
    10:01:35.612 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 5
    10:01:35.612 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 6
    10:01:35.613 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 7
    10:01:35.613 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 8
    10:01:35.613 [pool-1-thread-2] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 2 - 9
    10:01:35.607 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 0
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 1
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 2
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 3
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 4
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 5
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 6
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 7
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 8
    10:01:35.613 [pool-1-thread-1] INFO com.mmall.concurrency.example.sync.SynchronizedExample1 - test1 1 - 9
     */
}