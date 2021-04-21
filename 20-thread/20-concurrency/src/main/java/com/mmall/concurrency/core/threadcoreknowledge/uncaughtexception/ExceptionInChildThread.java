package com.mmall.concurrency.core.threadcoreknowledge.uncaughtexception;

/**
 * 9.1-9.3
 * 描述：单线程，抛出，处理，有异常堆栈 多线程，
 *      子线程发生异常，会有什么不同？
 * 子线程异常虽然可以打印出来，可是我们很难发现它。
 */
public class ExceptionInChildThread implements Runnable {

    public static void main(String[] args) {
        new Thread(new ExceptionInChildThread()).start();
        for (int i = 0; i < 1000; i++) {
            System.out.println(i);
        }
    }

    @Override
    public void run() {
        throw new RuntimeException();
    }
}
/* Output:
......
998
999
Exception in thread "Thread-0" java.lang.RuntimeException
	at com.mmall.concurrency.core.threadcoreknowledge.uncaughtexception.ExceptionInChildThread.run(ExceptionInChildThread.java:19)
	at java.lang.Thread.run(Thread.java:748)
*///~