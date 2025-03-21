package com.mmall.concurrency.core.threadcoreknowledge.stopthreads;

/**
 * 描述：     run方法内没有sleep或wait方法时，停止线程
 */
public class RightWayStopThreadWithoutSleep implements Runnable {

    @Override
    public void run() {
        int num = 0;
        while (!Thread.currentThread().isInterrupted() && num <= Integer.MAX_VALUE / 2) {
            if (num % 10000 == 0) {
                System.out.println(num + "是10000的倍数");
            }
            num++;
        }
        System.out.println("任务运行结束了");
    }

    public static void main(String[] args) throws InterruptedException {
        Thread thread = new Thread(new RightWayStopThreadWithoutSleep());
        thread.start();
        Thread.sleep(2000);
        thread.interrupt();
    }
}
/* Output:
0是10000的倍数
10000是10000的倍数
20000是10000的倍数

......

458210000是10000的倍数
458220000是10000的倍数
458230000是10000的倍数
458240000是10000的倍数
458250000是10000的倍数
458260000是10000的倍数
任务运行结束了
 */