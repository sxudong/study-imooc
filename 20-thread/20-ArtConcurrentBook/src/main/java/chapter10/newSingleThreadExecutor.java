package chapter10;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 10.2.2 SingleThreadExecutor详解
 * SingleThreadExecutor 是使用单个 worker 线程的 Executor。
 *
 * public static ExecutorService newSingleThreadExecutor() {
 *       return new FinalizableDelegatedExecutorService
 *                  (new ThreadPoolExecutor(1, 1,
 *                                          0L, TimeUnit.MILLISECONDS,
 *                                          new LinkedBlockingQueue<Runnable>()));
 * }
 *
 * corePoolSize 和 maximumPoolSize 被设置为 1。
 */
public class newSingleThreadExecutor {
    public static void main(String[] args) {

        ExecutorService executorService = Executors.newSingleThreadExecutor();
        for (int i = 0; i < 10; i++) {
            final int index = i;
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    System.out.println("task: " + index);
                }
            });
        }
        executorService.shutdown();
    }
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