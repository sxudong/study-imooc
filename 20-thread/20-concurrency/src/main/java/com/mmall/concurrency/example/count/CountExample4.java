package com.mmall.concurrency.example.count;

import com.mmall.concurrency.annoations.NotThreadSafe;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

/**
 * 4-4 可见性
 */
@Slf4j
@NotThreadSafe
public class CountExample4 {

    // 请求总数
    public static int clientTotal = 10000;

    // 同时并发执行的线程数
    public static int threadTotal = 200;

    // 通过这个示例证明volatile做计数操作不是线程安全的，同时证明了volatile不具备原子性
    public static volatile int count = 0;

    public static void main(String[] args) throws Exception {
        ExecutorService executorService = Executors.newCachedThreadPool();
        final Semaphore semaphore = new Semaphore(threadTotal);
        final CountDownLatch countDownLatch = new CountDownLatch(clientTotal);
        for (int i = 0; i < clientTotal ; i++) {
            executorService.execute(() -> {
                try {
                    semaphore.acquire();
                    add();
                    semaphore.release();
                } catch (Exception e) {
                    log.error("exception", e);
                }
                countDownLatch.countDown();
            });
        }
        countDownLatch.await();
        executorService.shutdown();
        log.info("count:{}", count); // count:9996
    }

    private static void add() {
        count++;
        // 1、count
        // 2、+1
        // 3、count
    }
}
