package com.mmall.concurrency.core.threadcoreknowledge.createthreads.wrongways;

/**
 * 描述：     lambda表达式创建线程
 */
public class Lambda {

    public static void main(String[] args) {
        new Thread(() -> System.out.println(Thread.currentThread().getName())).start();
    }
}
/* Output:
Thread-0
*///~






