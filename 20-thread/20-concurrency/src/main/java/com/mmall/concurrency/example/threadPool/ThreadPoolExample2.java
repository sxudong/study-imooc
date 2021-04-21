package com.mmall.concurrency.example.threadPool;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
public class ThreadPoolExample2 {

    public static void main(String[] args) {

        ExecutorService executorService = Executors.newFixedThreadPool(3);

        for (int i = 0; i < 10; i++) {
            final int index = i;
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    log.info("task:{}", index);
                }
            });
        }
        executorService.shutdown();
    }
    /* 3个线程在运行：
    19:21:15.878 [pool-1-thread-3] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:2
    19:21:15.878 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:0
    19:21:15.882 [pool-1-thread-3] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:3
    19:21:15.878 [pool-1-thread-2] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:1
    19:21:15.882 [pool-1-thread-2] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:6
    19:21:15.882 [pool-1-thread-2] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:7
    19:21:15.882 [pool-1-thread-2] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:8
    19:21:15.882 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:4
    19:21:15.882 [pool-1-thread-2] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:9
    19:21:15.882 [pool-1-thread-3] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample2 - task:5
     */
}
