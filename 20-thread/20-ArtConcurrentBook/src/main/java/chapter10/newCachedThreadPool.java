package chapter10;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * 10.2.3 CachedThreadPool���
 * CachedThreadPool��һ���������Ҫ�������̵߳��̳߳ء�
 *
 * public static ExecutorService newCachedThreadPool() {
 *      return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
 *                                   60L, TimeUnit.SECONDS,
 *                                   new SynchronousQueue<Runnable>());
 * }
 *
 * corePoolSize ������Ϊ 0���� corePool Ϊ�գ�
 * maximumPoolSize ������Ϊ Integer.MAX_VALUE���� maximumPool ���޽�ġ�
 * keepAliveTime ����Ϊ 60L����ζ�� CachedThreadPool �еĿ����̵߳ȴ���
 * ������ʱ��Ϊ 60 �룬�����̳߳��� 60 ��󽫻ᱻ��ֹ��
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
/* ÿ����һ��һ���µ��߳�ִ�У�
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