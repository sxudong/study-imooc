package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-7
 * 4.2.3 理解中断
 */
public class Interrupted {

    public static void main(String[] args) throws Exception {
        // sleepThread不停的尝试睡眠
        Thread sleepThread = new Thread(new SleepRunner(), "SleepThread");
        sleepThread.setDaemon(true);
        // busyThread不停的运行
        Thread busyThread = new Thread(new BusyRunner(), "BusyThread");
        busyThread.setDaemon(true);
        sleepThread.start();
        busyThread.start();
        // 休眠5秒，让sleepThread和busyThread充分运行
        TimeUnit.SECONDS.sleep(5);
        sleepThread.interrupt();
        busyThread.interrupt();
        System.out.println("SleepThread interrupted is " + sleepThread.isInterrupted());
        System.out.println("BusyThread interrupted is " + busyThread.isInterrupted());
        // 防止sleepThread和busyThread立刻退出
        TimeUnit.SECONDS.sleep(2);
    }

    // 可中断的阻塞示例 (将抛出 InterruptedException 异常)
    static class SleepRunner implements Runnable {
        @Override
        public void run() {
            while (true) {
                // 休眠10秒，并打印捕获的异常
                SleepUtils.second(10);
            }
        }
    }

    // 不可中断的阻塞示例
    static class BusyRunner implements Runnable {
        @Override
        public void run() {
            while (true) {
            }
        }
    }
}
/*  中断可以理解为线程的一个标识位属性，它表示一个运行中的线程是否被其他线程进行了中断操作。
    从结果可以看出，抛出InterruptedException的线程SleepThread，其中断标识位被清除了，
    而一直忙碌运作的线程BusyThread，中断标识位没有被清除。
 */
/* Output:
抛出 InterruptedException 异常捕获
SleepThread interrupted is false
BusyThread interrupted is true
 */