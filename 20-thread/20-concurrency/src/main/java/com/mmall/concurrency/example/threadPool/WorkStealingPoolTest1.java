package com.mmall.concurrency.example.threadPool;

import java.util.concurrent.*;

/**
 * 2.1、特点
 *
 * 可以传入线程的数量，不传入，则默认使用当前计算机中可用的 cpu 数量
 * 能够合理的使用 CPU 进行对任务操作（并行操作）
 * 适合使用在很耗时的任务中
 * 　　底层用的 ForkJoinPool 来实现的。 ForkJoinPool 的优势在于，可以充分利用多 cpu，多核 cpu 的优势，
 *    把一个任务拆分成多个“小任务”分发到不同的 cpu 核心上执行，执行完后再把结果收集到一起返回。
 */
public class WorkStealingPoolTest1 {
    public static void main(String[] args) throws InterruptedException {
        // 创建一个具有抢占式操作的线程池 1.8 之后新增 每个线程都有一个任务队列存放任务
        ExecutorService newWorkStealingPool = Executors.newWorkStealingPool(Runtime.getRuntime().availableProcessors());
        LinkedBlockingDeque<Future<String>> strings = new LinkedBlockingDeque<>();
        // CPU 核数
        System.out.println(Runtime.getRuntime().availableProcessors());
        CountDownLatch countDownLatch = new CountDownLatch(Runtime.getRuntime().availableProcessors());

        for (int i = 0; i < Runtime.getRuntime().availableProcessors()+1; i++) {
            // 执行
            Future<String> submit = newWorkStealingPool.submit(new Callable<String>() {
                @Override
                public String call() {
                    //System.out.println("展示线程：" + Thread.currentThread().getName());
                    try {
                        TimeUnit.SECONDS.sleep(2);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }finally {
                        //countDownLatch.countDown();
                    }
                    return "展示线程：" + Thread.currentThread().getName();
                }
            });
            strings.offer(submit);
        }

        //countDownLatch.await();

        System.out.println("over");
        newWorkStealingPool.shutdown();

        strings.forEach(f-> {
            try {
                System.out.println(f.get());
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (ExecutionException e) {
                e.printStackTrace();
            }
        });
    }
}
/* Output:
4
over
展示线程：ForkJoinPool-1-worker-1
展示线程：ForkJoinPool-1-worker-2
展示线程：ForkJoinPool-1-worker-3
展示线程：ForkJoinPool-1-worker-0
展示线程：ForkJoinPool-1-worker-2
*///~