package chapter10;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * 10.2.3 CachedThreadPool详解
 * CachedThreadPool是一个会根据需要创建新线程的线程池。
 *
 * public static ExecutorService newCachedThreadPool() {
 *      return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
 *                                   60L, TimeUnit.SECONDS,
 *                                   new SynchronousQueue<Runnable>());
 * }
 *
 * corePoolSize 被设置为 0，即 corePool 为空；
 * maximumPoolSize 被设置为 Integer.MAX_VALUE，即 maximumPool 是无界的。
 * keepAliveTime 设置为 60L，意味着 CachedThreadPool 中的空闲线程等待新
 * 任务的最长时间为 60 秒，空闲线程超过 60 秒后将会被终止。
 */
public class newCachedThreadPool {
    public static void main(String[] args) {
        ExecutorService executorService = Executors.newCachedThreadPool();

        for (int i = 0; i < 10; i++) {
            final int index = i;
            // executorService.execute(() -> log.info("task:{}", index));
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    System.out.println("task: " + index);
                }
            });
        }
        executorService.shutdown();
        ThreadPoolExecutor threadPoolExecutor = (ThreadPoolExecutor) executorService;
        System.out.println(threadPoolExecutor.getTaskCount());
    }
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