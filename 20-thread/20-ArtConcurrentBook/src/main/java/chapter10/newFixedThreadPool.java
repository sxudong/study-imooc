package chapter10;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


/**
 * 10.2.1 FixedThreadPool详解
 * FixedThreadPool被称为可重用固定线程数的线程池。
 *
 * public static ExecutorService newFixedThreadPool(int nThreads) {
 *      return new ThreadPoolExecutor(nThreads, nThreads,
 *                                   0L, TimeUnit.MILLISECONDS,
 *                                   new LinkedBlockingQueue<Runnable>());
 * }
 *
 * corePoolSize 和 maximumPoolSize 都被设置为创建 FixedThreadPool 时指定的参数 nThreads。
 * keepAliveTime 设置为 0L，意味着多余的空闲线程会被立即终止。
 */
public class newFixedThreadPool {

    public static void main(String[] args) {

        ExecutorService executorService = Executors.newFixedThreadPool(3);

        for (int i = 0; i < 10; i++) {
            final int index = i;
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    System.out.println("task: " + index);
                }
            });
        }
        // FixedThreadPool 的核心线程没有超时策略，所以并不会自动关闭。
        // 所以我们在使用 FixedThreadPool 核心线程时需要适当调用 Shutdown 方法，防止内存溢出。
        executorService.shutdown();
    }
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