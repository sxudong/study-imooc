package chapter08.semaphore;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

/**
 * 7-2 AQS的同步组件 Semaphore
 */
public class SemaphoreExample3 {

    private final static int threadCount = 20;

    public static void main(String[] args) throws Exception {

        ExecutorService exec = Executors.newCachedThreadPool();

        final Semaphore semaphore = new Semaphore(3);

        for (int i = 0; i < threadCount; i++) {
            final int threadNum = i;
            exec.execute(() -> {
                try {
                        //if (semaphore.tryAcquire(5, TimeUnit.SECONDS)) {
                        if (semaphore.tryAcquire()) {  // 尝试获取一个许可,获取不到不执行
                        test(threadNum);
                        semaphore.release(); // 释放一个许可
                    }
                } catch (Exception e) {
                    System.out.println("exception: " + e);
                }
            });
        }
        exec.shutdown();
    }

    private static void test(int threadNum) throws Exception {
        System.out.println(threadNum);
        Thread.sleep(1000);
    }
}
/*
    21:13:45.637 [pool-1-thread-1] INFO com.mmall.concurrency.example.aqs.SemaphoreExample3 - 0
    21:13:45.637 [pool-1-thread-2] INFO com.mmall.concurrency.example.aqs.SemaphoreExample3 - 1
    21:13:45.637 [pool-1-thread-3] INFO com.mmall.concurrency.example.aqs.SemaphoreExample3 - 2
 */
