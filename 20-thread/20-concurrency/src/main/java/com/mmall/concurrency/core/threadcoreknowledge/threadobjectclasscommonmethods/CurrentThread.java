package com.mmall.concurrency.core.threadcoreknowledge.threadobjectclasscommonmethods;

/**
 * Java并发编程精讲 7.1-7.15
 * 描述：演示打印main, Thread-0, Thread-1
 */
public class CurrentThread implements Runnable {

    public static void main(String[] args) {
        new CurrentThread().run();
        new Thread(new CurrentThread()).start();
        new Thread(new CurrentThread()).start();
    }

    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName());
    }
}
/* Output:
main
Thread-0
Thread-1
*///~