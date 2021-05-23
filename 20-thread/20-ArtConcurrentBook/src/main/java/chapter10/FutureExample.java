package chapter10;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * 10.4 FutureTask详解
 * 代表异步计算的结果。
 *
 * FutureTask 除了实现 Future 接口外，还实现了 Runnable 接口。因此，FutureTask 可以交给
 * Executor 执行，也可以由调用线程直接执行（FutureTask.run()）。
 */
public class FutureExample {

    static class MyCallable implements Callable<String> {

        @Override
        public String call() throws Exception {
            System.out.println("do something in callable");
            Thread.sleep(5000);
            return "Done"; //返回结果
        }
    }

    public static void main(String[] args) throws Exception {
        ExecutorService executorService = Executors.newCachedThreadPool();
        // 通过 Future 接收另外一个线程的结果
        Future<String> future = executorService.submit(new MyCallable());

        System.out.println("do something in main");
        Thread.sleep(1000);
        String result = future.get();
        System.out.println("result：" + result);
    }
}
/* Output:
do something in callable
do something in main
result：Done
*///:~