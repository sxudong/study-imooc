package com.mmall.concurrency.core.threadcoreknowledge.threadobjectclasscommonmethods;

/**
 * 7.1-7.15
 * 展示线程sleep的时候不释放synchronized的monitor，
 * 等sleep时间到了以后，正常结束后才释放锁。
 */
public class SleepDontReleaseMonitor implements Runnable {

    public static void main(String[] args) {
        SleepDontReleaseMonitor sleepDontReleaseMonitor = new SleepDontReleaseMonitor();
        new Thread(sleepDontReleaseMonitor).start();
        new Thread(sleepDontReleaseMonitor).start();
    }

    @Override
    public void run() {
        syn();
    }

    // 方法锁
    private synchronized void syn() {
        System.out.println("线程" + Thread.currentThread().getName() + "获取到了monitor。");
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("线程" + Thread.currentThread().getName() + "退出了同步代码块");
    }
}
/* Output:
线程Thread-0获取到了monitor。
线程Thread-0退出了同步代码块
线程Thread-1获取到了monitor。
线程Thread-1退出了同步代码块
*///~