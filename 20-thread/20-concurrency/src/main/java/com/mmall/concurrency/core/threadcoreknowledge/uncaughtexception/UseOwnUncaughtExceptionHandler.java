package com.mmall.concurrency.core.threadcoreknowledge.uncaughtexception;

/**
 * 9.1-9.3
 * 描述：使用刚才自己写的UncaughtExceptionHandler
 */
public class UseOwnUncaughtExceptionHandler implements Runnable {

    public static void main(String[] args) throws InterruptedException {
        Thread.setDefaultUncaughtExceptionHandler(new MyUncaughtExceptionHandler("捕获器1"));

        new Thread(new UseOwnUncaughtExceptionHandler(), "MyThread-1").start();
        Thread.sleep(300);
        new Thread(new UseOwnUncaughtExceptionHandler(), "MyThread-2").start();
        Thread.sleep(300);
        new Thread(new UseOwnUncaughtExceptionHandler(), "MyThread-3").start();
        Thread.sleep(300);
        new Thread(new UseOwnUncaughtExceptionHandler(), "MyThread-4").start();
    }

    @Override
    public void run() {
        throw new RuntimeException();
    }
}
/* Output:
四月 19, 2020 1:31:50 下午 com.mmall.concurrency.core.threadcoreknowledge.uncaughtexception.MyUncaughtExceptionHandler uncaughtException
警告: 线程异常，终止啦MyThread-1
捕获器1捕获了异常MyThread-1异常
捕获器1捕获了异常MyThread-2异常
四月 19, 2020 1:31:50 下午 com.mmall.concurrency.core.threadcoreknowledge.uncaughtexception.MyUncaughtExceptionHandler uncaughtException
警告: 线程异常，终止啦MyThread-2
捕获器1捕获了异常MyThread-3异常
四月 19, 2020 1:31:50 下午 com.mmall.concurrency.core.threadcoreknowledge.uncaughtexception.MyUncaughtExceptionHandler uncaughtException
警告: 线程异常，终止啦MyThread-3
四月 19, 2020 1:31:51 下午 com.mmall.concurrency.core.threadcoreknowledge.uncaughtexception.MyUncaughtExceptionHandler uncaughtException
警告: 线程异常，终止啦MyThread-4
捕获器1捕获了异常MyThread-4异常
*///~