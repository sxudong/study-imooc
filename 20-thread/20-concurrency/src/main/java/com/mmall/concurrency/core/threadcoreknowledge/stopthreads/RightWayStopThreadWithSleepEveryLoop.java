package com.mmall.concurrency.core.threadcoreknowledge.stopthreads;

/**
 * 描述：     如果在执行过程中，每次循环都会调用sleep或wait等方法，那么不需要每次迭代都检查是否已中断
 */
public class RightWayStopThreadWithSleepEveryLoop {
    public static void main(String[] args) throws InterruptedException {
        Runnable runnable = () -> {
            int num = 0;
            try {
                while (num <= 10000) {
                    if (num % 100 == 0) {
                        System.out.println(num + "是100的倍数");
                    }
                    num++;
                    Thread.sleep(10);
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        };
        Thread thread = new Thread(runnable);
        thread.start();
        Thread.sleep(5000);
        thread.interrupt();
    }
}
/* Output:
0是100的倍数
100是100的倍数
200是100的倍数
300是100的倍数
400是100的倍数
java.lang.InterruptedException: sleep interrupted
	at java.lang.Thread.sleep(Native Method)
	at com.mmall.concurrency.core.threadcoreknowledge.stopthreads.RightWayStopThreadWithSleepEveryLoop.lambda$main$0(RightWayStopThreadWithSleepEveryLoop.java:16)
	at java.lang.Thread.run(Thread.java:748)
*///~