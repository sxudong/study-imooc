package com.mmall.concurrency.core.threadcoreknowledge.threadobjectclasscommonmethods;

/**
 * 7.1-7.15
 * 描述：演示join期间被中断的效果
 */
public class JoinInterrupt {
    public static void main(String[] args) {
        Thread mainThread = Thread.currentThread();
        Thread thread1 = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // 用主线程的引用去中断主线程
                    mainThread.interrupt();
                    Thread.sleep(5000);
                    System.out.println("Thread1 finished.");
                } catch (InterruptedException e) {
                    System.out.println("子线程中断");
                }
            }
        });

        thread1.start();
        System.out.println("等待子线程运行完毕");
        try {
            thread1.join(); //子线程回入主线程
        } catch (InterruptedException e) {
            System.out.println(Thread.currentThread().getName() + "主线程中断了");
            thread1.interrupt();
        }
        System.out.println("子线程已运行完毕");
    }
}
/* Output:
等待子线程运行完毕
main主线程中断了
子线程已运行完毕
子线程中断
*///~