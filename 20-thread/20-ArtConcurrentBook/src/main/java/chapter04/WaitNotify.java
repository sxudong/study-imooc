package chapter04;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-11
 * 4.3.2 等待/通知机制
 *
 * 例子中，创建了两个线程 —— WaitThread 和 NotifyThread，前者检查 flag 值是否为 false，
 * 如果符合要求，进行后续操作，否则在 lock 上等待，后者在睡眠了一段时间后对 lock 进行通知。
 *
 */
public class WaitNotify {
    static boolean flag = true;
    static Object  lock = new Object();

    public static void main(String[] args) throws Exception {
        Thread waitThread = new Thread(new Wait(), "WaitThread");
        waitThread.start();
        TimeUnit.SECONDS.sleep(1);

        Thread notifyThread = new Thread(new Notify(), "NotifyThread");
        notifyThread.start();
    }

    static class Wait implements Runnable {
        public void run() {
            // 加锁，拥有lock的Monitor
            synchronized (lock) {
                // 当条件不满足时，继续wait，同时释放了lock的锁
                while (flag) {
                    try {
                        System.out.println(Thread.currentThread() + " flag is true. wait @ "
                                           + new SimpleDateFormat("HH:mm:ss").format(new Date()));
                        lock.wait();  // 放弃了锁,并进入了对象的等待队列
                    } catch (InterruptedException e) {
                    }
                }
                // 条件满足时，完成工作
                System.out.println(Thread.currentThread() + " flag is false. running @ "
                                   + new SimpleDateFormat("HH:mm:ss").format(new Date()));
            }
        }
    }

    static class Notify implements Runnable {
        public void run() {
            // 加锁，拥有lock的Monitor
            synchronized (lock) {
                // 获取 lock 的锁，然后notifyAll()进行通知，通知时不会释放lock的锁，
                // 直到当前线程释放了lock后，WaitThread才能从wait方法中返回
                System.out.println(Thread.currentThread() + " hold lock. notify @ " + new SimpleDateFormat("HH:mm:ss").format(new Date()));
                lock.notifyAll();
                flag = false;
                SleepUtils.second(5);
            }
            // 再次加锁
            synchronized (lock) {
                System.out.println(Thread.currentThread() + " hold lock again. sleep @ "
                                   + new SimpleDateFormat("HH:mm:ss").format(new Date()));
                SleepUtils.second(5);
            } // 释放锁
        }
    }
}
/* Output:
Thread[WaitThread,5,main] flag is true. wait @ 12:39:18
Thread[NotifyThread,5,main] hold lock. notify @ 12:39:19
Thread[WaitThread,5,main] flag is false. running @ 12:39:24
Thread[NotifyThread,5,main] hold lock again. sleep @ 12:39:24
 */