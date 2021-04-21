package com.mmall.concurrency.example.aqs;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

/**
 * 7-2 AQS的同步组件 Semaphore
 */
@Slf4j
public class SemaphoreExample2 {

    private final static int threadCount = 20;

    public static void main(String[] args) throws Exception {

        ExecutorService exec = Executors.newCachedThreadPool();

        final Semaphore semaphore = new Semaphore(3);

        for (int i = 0; i < threadCount; i++) {
            final int threadNum = i;
            exec.execute(() -> {
                try {
                    semaphore.acquire(3); // 获取多个许可
                    test(threadNum);
                    semaphore.release(3); // 释放多个许可
                } catch (Exception e) {
                    log.error("exception", e);
                }
            });
        }
        exec.shutdown();
    }

    private static void test(int threadNum) throws Exception {
        log.info("{}", threadNum);
        Thread.sleep(1000);
    }
}
/* 一次拿3个许可，同1秒钟已经没有别的许可可以释放出来了，这个时候跟单线程很像。它拿到3个许可之后，
    要都做完，下一个才可以继续。
    13:33:56.456 [pool-1-thread-1] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 0
    13:33:57.464 [pool-1-thread-2] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 1
    13:33:58.464 [pool-1-thread-3] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 2
    13:33:59.464 [pool-1-thread-4] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 3
    13:34:00.465 [pool-1-thread-5] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 4
    13:34:01.465 [pool-1-thread-6] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 5
    13:34:02.465 [pool-1-thread-7] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 6
    13:34:03.466 [pool-1-thread-8] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 7
    13:34:04.466 [pool-1-thread-9] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 8
    13:34:05.466 [pool-1-thread-10] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 9
    13:34:06.467 [pool-1-thread-11] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 10
    13:34:07.467 [pool-1-thread-12] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 11
    13:34:08.467 [pool-1-thread-13] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 12
    13:34:09.468 [pool-1-thread-14] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 13
    13:34:10.468 [pool-1-thread-15] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 14
    13:34:11.468 [pool-1-thread-16] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 15
    13:34:12.469 [pool-1-thread-17] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 16
    13:34:13.469 [pool-1-thread-18] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 17
    13:34:14.469 [pool-1-thread-19] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 18
    13:34:15.470 [pool-1-thread-20] INFO com.mmall.concurrency.example.aqs.SemaphoreExample2 - 19
 */
