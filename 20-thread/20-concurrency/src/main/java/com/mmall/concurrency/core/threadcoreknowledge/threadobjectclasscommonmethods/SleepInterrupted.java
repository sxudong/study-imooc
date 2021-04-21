package com.mmall.concurrency.core.threadcoreknowledge.threadobjectclasscommonmethods;

import java.util.concurrent.TimeUnit;

/**
 * 7.1-7.15
 * 描述：每个1秒钟输出当前时间，被中断，观察。
 * Thread.sleep()
 * TimeUnit.SECONDS.sleep()
 */
public class SleepInterrupted implements Runnable{

    public static void main(String[] args) throws InterruptedException {
        Thread thread = new Thread(new SleepInterrupted());
        thread.start();
        Thread.sleep(5000);
        thread.interrupt();
    }
    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            System.out.println(i);
            try {
                //TimeUnit.HOURS.sleep(3);
                //TimeUnit.MINUTES.sleep(1);
                TimeUnit.SECONDS.sleep(1); // Thread.sleep(1000);
            } catch (InterruptedException e) {
                System.out.println("我被中断了！");
                e.printStackTrace();
            }
        }
    }
}
/* Output:
0
1
2
3
4
我被中断了！
5
java.lang.InterruptedException: sleep interrupted
	at java.lang.Thread.sleep(Native Method)
	at java.lang.Thread.sleep(Thread.java:340)
	at java.util.concurrent.TimeUnit.sleep(TimeUnit.java:386)
	at com.mmall.concurrency.core.threadcoreknowledge.threadobjectclasscommonmethods.SleepInterrupted.run(SleepInterrupted.java:26)
	at java.lang.Thread.run(Thread.java:748)
6
7
8
9
*///~