package com.mmall.concurrency.example.aqs;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

/**
 * 7-2 AQS的同步组件 Semaphore
 */
@Slf4j
public class SemaphoreExample1 {

    // 20个请求
    private final static int threadCount = 20;

    public static void main(String[] args) throws Exception {

        ExecutorService exec = Executors.newCachedThreadPool();

        final Semaphore semaphore = new Semaphore(3);

        for (int i = 0; i < threadCount; i++) {
            final int threadNum = i;
            exec.execute(() -> {
                try {
                    semaphore.acquire(); // 获取一个许可
                    test(threadNum);
                    semaphore.release(); // 释放一个许可
                } catch (Exception e) {
                    log.error("exception", e);
                }
            });
        }
        exec.shutdown();
    }

    private static void test(int threadNum) throws Exception {
        log.info("{}", threadNum); //19
        Thread.sleep(1000);
    }
}
/* 每1秒只能放3个：
    13:28:39.553 [pool-1-thread-3] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 2
    13:28:39.553 [pool-1-thread-2] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 1
    13:28:39.553 [pool-1-thread-1] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 0
    13:28:40.559 [pool-1-thread-4] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 3
    13:28:40.559 [pool-1-thread-5] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 4
    13:28:40.559 [pool-1-thread-6] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 5
    13:28:41.559 [pool-1-thread-8] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 7
    13:28:41.559 [pool-1-thread-9] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 8
    13:28:41.559 [pool-1-thread-7] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 6
    13:28:42.559 [pool-1-thread-11] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 10
    13:28:42.559 [pool-1-thread-10] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 9
    13:28:42.560 [pool-1-thread-12] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 11
    13:28:43.560 [pool-1-thread-13] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 12
    13:28:43.560 [pool-1-thread-14] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 13
    13:28:43.561 [pool-1-thread-15] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 14
    13:28:44.560 [pool-1-thread-16] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 15
    13:28:44.560 [pool-1-thread-17] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 16
    13:28:44.561 [pool-1-thread-18] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 17
    13:28:45.560 [pool-1-thread-19] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 18
    13:28:45.561 [pool-1-thread-20] INFO com.mmall.concurrency.example.aqs.SemaphoreExample1 - 19
 */
