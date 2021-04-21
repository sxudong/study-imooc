package com.mmall.concurrency.example.threadPool;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
public class ThreadPoolExample3 {

    public static void main(String[] args) {

        ExecutorService executorService = Executors.newSingleThreadExecutor();

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
    /* 单线程执行：
    19:24:02.672 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:0
    19:24:02.678 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:1
    19:24:02.678 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:2
    19:24:02.678 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:3
    19:24:02.678 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:4
    19:24:02.679 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:5
    19:24:02.679 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:6
    19:24:02.679 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:7
    19:24:02.679 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:8
    19:24:02.679 [pool-1-thread-1] INFO com.mmall.concurrency.example.threadPool.ThreadPoolExample3 - task:9
     */
}
