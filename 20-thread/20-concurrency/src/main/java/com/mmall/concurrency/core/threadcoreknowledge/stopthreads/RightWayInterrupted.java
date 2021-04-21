package com.mmall.concurrency.core.threadcoreknowledge.stopthreads;

/**
 * 5.1-5.10 (下)
 * Thread.interrupted()方法的目标对象是“当前线程”，
 * 而不管本方法来自于哪个对象。
 */
public class RightWayInterrupted {

    public static void main(String[] args) throws InterruptedException {
        Thread threadOne = new Thread(() -> {
            for (; ; ) {
            }
        });

        // 启动线程
        threadOne.start();
        //设置中断标志
        threadOne.interrupt();
        //获取中断标志
        System.out.println("isInterrupted: " + threadOne.isInterrupted());
        //获取中断标志并重置
        System.out.println("isInterrupted: " + threadOne.interrupted()); //再次调用
        //获取中断标志并重直
        System.out.println("isInterrupted: " + Thread.interrupted()); // 当前主线程
        //获取中断标志
        System.out.println("isInterrupted: " + threadOne.isInterrupted());
        threadOne.join();
        System.out.println("Main thread is over.");
    }
}
/* Output:
isInterrupted: true
isInterrupted: false //main函数没有被中断，所以返回false
isInterrupted: false
isInterrupted: true
*///~
