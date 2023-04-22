package chapter10;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

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
    //private static final ExecutorService executorService = Executors.newSingleThreadExecutor();
    public static void main(String[] args) throws InterruptedException {

        // execute 和 submit 的区别
        // https://blog.csdn.net/qq_50652600/article/details/123417584
        ExecutorService executorService = Executors.newSingleThreadExecutor();
        for (int i = 0; i < 10; i++) {
            final int index = i;
            //executorService.submit(new Runnable() {
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        //处理逻辑
                        System.out.println("task: " + index);
                    } catch(Exception e) {
                        //打印日志
                    }
                }
            });
        }
        // Java多线程 关闭线程池 shutdown() 、shutdownNow()、awaitTermination()
        // https://blog.csdn.net/qq_46207024/article/details/124353321
        // 做为对象的私有属性，不是重复new就不用关闭，否则线程不会关闭会造成内存溢出。
        // 只关闭了提交通道，停止接收新任务，已提交的任务会继续执行直到完成，此方法不会阻塞，当所有提交任务执行完毕，线程池被关闭
        executorService.shutdown();
        // 如果任务执行时间很长，可以按超时终止它
        try {
            // 如果在超时之前所有任务执行完毕，表示线程池已经终止，返回true，否则返回false
            if(!executorService.awaitTermination(60, TimeUnit.SECONDS)){
                // 立即停止线程池，停止接收新任务，中断所有正在执行的任务，停止对等待队列的处理，立刻返回未执行的任务列表
                executorService.shutdownNow();
            }
            System.out.println("AwaitTermination Finished");
        } catch (InterruptedException ignore) {
            executorService.shutdownNow();
        }
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