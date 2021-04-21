package com.mmall.concurrency.example.threadPool;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
public class ThreadPoolExample1 {

    public static void main(String[] args) {

        ExecutorService executorService = Executors.newCachedThreadPool();

        for (int i = 0; i < 10; i++) {
            final int index = i;
            // executorService.execute(() -> log.info("task:{}", index));
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    log.info("task:{}", index);
                }
            });
        }
        executorService.shutdown();
    }
    /* 每运行一次一个新的线程执行：
    19:22:30.173 [pool-1-thread-6] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:5
    19:22:30.173 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:0
    19:22:30.173 [pool-1-thread-4] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:3
    19:22:30.173 [pool-1-thread-2] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:1
    19:22:30.173 [pool-1-thread-3] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:2
    19:22:30.173 [pool-1-thread-9] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:8
    19:22:30.173 [pool-1-thread-10] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:9
    19:22:30.172 [pool-1-thread-8] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:7
    19:22:30.173 [pool-1-thread-7] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:6
    19:22:30.172 [pool-1-thread-5] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample1 - task:4
     */
}
