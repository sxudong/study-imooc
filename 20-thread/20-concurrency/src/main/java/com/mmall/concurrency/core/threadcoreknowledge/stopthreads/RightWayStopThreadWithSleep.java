package com.mmall.concurrency.core.threadcoreknowledge.stopthreads;

/**
 * 描述：     带有sleep的中断线程的写法
 */
public class RightWayStopThreadWithSleep {

    public static void main(String[] args) throws InterruptedException {
        Runnable runnable = () -> {
            int num = 0;
            try {
                while (num <= 300 && !Thread.currentThread().isInterrupted()) {
                    if (num % 100 == 0) {
                        System.out.println(num + "是100的倍数");
                    }
                    num++;
                }
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        };
        Thread thread = new Thread(runnable);
        thread.start();
        Thread.sleep(500);
        thread.interrupt();
    }
}
/* Output:
0是100的倍数
100是100的倍数
200是100的倍数
300是100的倍数
java.lang.InterruptedException: sleep interrupted
	at java.lang.Thread.sleep(Native Method)
	at com.mmall.concurrency.core.threadcoreknowledge.stopthreads.RightWayStopThreadWithSleep.lambda$main$0(RightWayStopThreadWithSleep.java:18)
	at java.lang.Thread.run(Thread.java:748)
*///~