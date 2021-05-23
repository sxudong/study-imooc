package chapter10;

import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

/**
 * 10.4 FutureTask详解
 * 代表异步计算的结果。
 *
 * FutureTask 除了实现 Future 接口外，还实现了 Runnable 接口。因此，FutureTask 可以交给
 * Executor 执行，也可以由调用线程直接执行（FutureTask.run()）
 */
public class FutureTaskExample {

    public static void main(String[] args) throws Exception {
        // 创建 FutureTask
        FutureTask<String> futureTask = new FutureTask<String>(new Callable<String>() {
            @Override
            public String call() throws Exception {
                System.out.println("do something in callable");
                Thread.sleep(5000);
                return "Done"; // 返回值
            }
        });

        // 将 FutureTask 交给 Thread 运行
        new Thread(futureTask).start();
        System.out.println("do something in main");
        Thread.sleep(1000);
        // FutureTask.get() 获取返回值
        String result = futureTask.get();
        System.out.println("result：" + result);
    }
}
/* Output:
do something in main
do something in callable
result：Done
*///:~