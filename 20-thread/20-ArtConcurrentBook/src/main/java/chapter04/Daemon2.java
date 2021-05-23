package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-5
 * 4.1.5 Daemon（后台）线程
 */
public class Daemon2 {

    public static void main(String[] args) throws InterruptedException {
        Thread thread = new Thread(new DaemonRunner());
        thread.setDaemon(true); //设置为后台守护线程
        thread.start();

        for (int i = 0; i < 10; i++) {
            Thread daemon = new Thread(new SimpleDaemons());
            daemon.setDaemon(true); // Must call before start() 如果注释掉，创建的线程就会一直运行，不会走向死亡
            daemon.start();
        }
        System.out.println("All daemons started");
        TimeUnit.MILLISECONDS.sleep(500); // main 主线程休眠0.5秒，然后主线程走向消失，后台程序也走向死亡
    }

    static class DaemonRunner implements Runnable {
        @Override
        public void run() {
            try {
                SleepUtils.second(100);
            } finally {
                System.out.println("DaemonThread finally run.");
            }
        }
    }
}

//代码来自《Java编程思想四》
class SimpleDaemons implements Runnable {
    @Override
    public void run() {
        try {
            while (true) {
                TimeUnit.MILLISECONDS.sleep(100);
                System.out.println(Thread.currentThread() + " " + this);
            }
        } catch (InterruptedException e) {
            System.out.println("sleep() interrupted");
        }
    }
}
/* Output:
All daemons started
Thread[Thread-1,5,main] chapter04.SimpleDaemons@6f9777db
Thread[Thread-2,5,main] chapter04.SimpleDaemons@710a3057
Thread[Thread-3,5,main] chapter04.SimpleDaemons@7f05b150
Thread[Thread-4,5,main] chapter04.SimpleDaemons@2cf9cd59
......
 */