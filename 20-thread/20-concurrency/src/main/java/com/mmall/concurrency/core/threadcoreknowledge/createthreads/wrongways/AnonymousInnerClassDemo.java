package com.mmall.concurrency.core.threadcoreknowledge.createthreads.wrongways;

/**
 * 描述：     匿名内部类的方式
 */
public class AnonymousInnerClassDemo {

    public static void main(String[] args) {
        new Thread(){
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getName());
            }
        }.start();
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getName());
            }
        }).start();
    }
}
/* Output:
Thread-0
Thread-1
*///~