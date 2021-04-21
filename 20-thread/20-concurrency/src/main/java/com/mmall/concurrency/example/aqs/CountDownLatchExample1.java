package com.mmall.concurrency.example.aqs;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * 7-2 AQS的同步组件 CountDownLatch(闭锁)
 *
 * 概念：
 *   你可以向 CountDownLatch 对象设置一个初始计数值，任何在这个对象上调用await()的方法都将阻塞，
 *   直至这个计数值到达0.其他任务在结束工作时，可以在该对象上调用countDown()来减少这个计数值。
 *   CountDownLatch 只触发一次，计数值不能被重置。
 *
 */
@Slf4j
public class CountDownLatchExample1 {

    private final static int threadCount = 200;

    public static void main(String[] args) throws Exception {

        ExecutorService exec = Executors.newCachedThreadPool();

        final CountDownLatch countDownLatch = new CountDownLatch(threadCount);

        for (int i = 0; i < threadCount; i++) {
            final int threadNum = i;
            exec.execute(() -> {
                try {
                    test(threadNum);
                } catch (Exception e) {
                    log.error("exception", e);
                } finally {
                    //注意如果出现异常，放到finally里执行
                    countDownLatch.countDown(); //将count值减1
                }
            });
        }
        //给定等待时间，如果忘记写countDownLatch.countDown()它也会继续执行下去
        //调用await()方法的线程会被挂起，它会等待直到count值为0才继续执行
        countDownLatch.await(10, TimeUnit.SECONDS);
        //countDownLatch.await();
        log.info("finish");
        exec.shutdown();
    }

    private static void test(int threadNum) throws Exception {
        Thread.sleep(100);
        log.info("{}", threadNum); //输出的最后一个数值是199
        Thread.sleep(100);
    }
}
