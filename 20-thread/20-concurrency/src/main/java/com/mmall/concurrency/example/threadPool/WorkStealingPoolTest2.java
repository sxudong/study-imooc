package com.mmall.concurrency.example.threadPool;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class WorkStealingPoolTest2 {
    public static void main(String[] args) {
        // 创建一个线程池，维护足够的线程以支持给定的并行度级别，并且可以使用多个队列来减少争用。
        // 并行度级别对应于主动参与或可用于参与任务处理的最大线程数。
        // 线程的实际数量可能会动态增长和收缩。
        // 工作窃取池不保证提交任务的执行顺序。
        // 并行度——目标并行度级别
        //一个拥有多个任务队列的线程池，可以减少连接数，创建当前可用cpu数量的线程来并行执行。
        ExecutorService forkJoin = Executors.newWorkStealingPool();

        forkJoin.execute(new Runnable() {
            @Override
            public void run() {
                System.out.println("i====>" + 1);
            }
        });

        forkJoin.execute(new Runnable() {
            @Override
            public void run() {
                System.out.println("i====>" + 2);
            }
        });

        forkJoin.execute(new Runnable() {
            @Override
            public void run() {
                System.out.println("i====>" + 3);
            }
        });

        forkJoin.execute(new Runnable() {
            @Override
            public void run() {
                System.out.println("i====>" + 4);
            }
        });

        forkJoin.shutdown();
    }
}
/* Output:
i====>1
i====>2
i====>3
i====>4
*///~