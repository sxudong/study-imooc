package com.mmall.concurrency.example.aqs;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.Future;
import java.util.concurrent.RecursiveTask;

/**
 * 8-3 Fork/Join
 */
@Slf4j
public class ForkJoinTaskExample extends RecursiveTask<Integer> {

    public static final int threshold = 2;
    private int start;
    private int end;

    public ForkJoinTaskExample(int start, int end) {
        this.start = start;
        this.end = end;
    }

    @Override
    protected Integer compute() {
        int sum = 0;

        // 小于阈值, 直接计算
        boolean canCompute = (end - start) <= threshold;
        if (canCompute) {
            for (int i = start; i <= end; i++) {
                sum += i;
            }
        // 如果任务大于阈值
        } else {
            // 1.分裂成两个子任务计算
            int middle = (start + end) / 2;
            ForkJoinTaskExample leftTask = new ForkJoinTaskExample(start, middle);
            ForkJoinTaskExample rightTask = new ForkJoinTaskExample(middle + 1, end);

            // 2.执行子任务
            leftTask.fork();
            rightTask.fork();

            // 3.等待任务执行结束合并其结果
            int leftResult = leftTask.join();   // 加入一个线程
            int rightResult = rightTask.join(); // 加入一个线程

            // 4.合并子任务结果
            sum = leftResult + rightResult;
        }
        return sum;
    }

    public static void main(String[] args) {
        //ForkJoinTask 需要通过 ForkJoinPool 来执行
        ForkJoinPool forkjoinPool = new ForkJoinPool();

        //生成一个计算任务，计算1+2+3+4
        ForkJoinTaskExample task = new ForkJoinTaskExample(1, 100);

        //执行一个任务
        Future<Integer> result = forkjoinPool.submit(task);

        try {
            log.info("result:{}", result.get()); //result:5050
        } catch (Exception e) {
            log.error("exception", e);
        }
    }
}
/* Output:
result:5050
*///:~
