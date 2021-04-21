package com.mmall.concurrency.example.aqs;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * 7-4 同步辅助类 CyclicBarrier
 */
@Slf4j
public class CyclicBarrierExample2 {

    // 告诉线程有多少个线程要来同步等待
    private static CyclicBarrier barrier = new CyclicBarrier(5);

    public static void main(String[] args) throws Exception {

        ExecutorService executor = Executors.newCachedThreadPool();

        for (int i = 0; i < 10; i++) {
            final int threadNum = i;
            Thread.sleep(1000);
            executor.execute(() -> {
                try {
                    race(threadNum);
                } catch (Exception e) {
                    log.error("exception", e);
                }
            });
        }
        executor.shutdown();
    }

    private static void race(int threadNum) throws Exception {
        Thread.sleep(1000);
        log.info("{} is ready", threadNum);
        try {
            // 等待2秒后,不再等待其它线程都执行完，直接强制执行
            // 此时如果时间太短，会抛异常
            barrier.await(2000, TimeUnit.MILLISECONDS);
        } catch (Exception e) {
            log.warn("BarrierException", e);
        }
        log.info("{} continue", threadNum);
    }
}
/*
23:27:00.031 [pool-1-thread-1] INFO com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - 0 is ready
23:27:01.030 [pool-1-thread-2] INFO com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - 1 is ready
23:27:02.031 [pool-1-thread-3] INFO com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - 2 is ready
23:27:02.040 [pool-1-thread-1] WARN com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - BarrierException
java.util.concurrent.TimeoutException: null
	at java.util.concurrent.CyclicBarrier.dowait(CyclicBarrier.java:257)
	at java.util.concurrent.CyclicBarrier.await(CyclicBarrier.java:435)
	at com.mmall.concurrency.example.aqs.CyclicBarrierExample2.race(CyclicBarrierExample2.java:42)
	at com.mmall.concurrency.example.aqs.CyclicBarrierExample2.lambda$main$0(CyclicBarrierExample2.java:28)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:748)
23:27:02.041 [pool-1-thread-1] INFO com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - 0 continue
23:27:02.040 [pool-1-thread-2] WARN com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - BarrierException
java.util.concurrent.BrokenBarrierException: null
	at java.util.concurrent.CyclicBarrier.dowait(CyclicBarrier.java:250)
	at java.util.concurrent.CyclicBarrier.await(CyclicBarrier.java:435)
	at com.mmall.concurrency.example.aqs.CyclicBarrierExample2.race(CyclicBarrierExample2.java:42)
	at com.mmall.concurrency.example.aqs.CyclicBarrierExample2.lambda$main$0(CyclicBarrierExample2.java:28)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:748)
23:27:02.041 [pool-1-thread-2] INFO com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - 1 continue
23:27:02.040 [pool-1-thread-3] WARN com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - BarrierException
java.util.concurrent.BrokenBarrierException: null
	at java.util.concurrent.CyclicBarrier.dowait(CyclicBarrier.java:250)
	at java.util.concurrent.CyclicBarrier.await(CyclicBarrier.java:435)
	at com.mmall.concurrency.example.aqs.CyclicBarrierExample2.race(CyclicBarrierExample2.java:42)
	at com.mmall.concurrency.example.aqs.CyclicBarrierExample2.lambda$main$0(CyclicBarrierExample2.java:28)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:748)
23:27:02.041 [pool-1-thread-3] INFO com.mmall.concurrency.example.aqs.CyclicBarrierExample2 - 2 continue
 */
