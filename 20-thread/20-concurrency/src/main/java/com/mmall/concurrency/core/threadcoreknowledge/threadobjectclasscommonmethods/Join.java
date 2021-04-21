package com.mmall.concurrency.core.threadcoreknowledge.threadobjectclasscommonmethods;

/**
 * 7.1-7.15
 * 描述：演示join，注意语句输出顺序，会变化。
 */
public class Join {
    public static void main(String[] args) throws InterruptedException {
        Thread thread1 = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread().getName() + "执行完毕");
            }
        });

        Thread thread2 = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread().getName() + "执行完毕");
            }
        });

        thread1.start();
        thread2.start();
        System.out.println("开始等待子线程运行完毕");
        thread1.join(); //将thread1加入到主线程
        thread2.join(); //将thread2加入到主线程
        System.out.println("所有子线程执行完毕");
    }
}
/* Output:
开始等待子线程运行完毕
Thread-0执行完毕
Thread-1执行完毕
所有子线程执行完毕
*///~