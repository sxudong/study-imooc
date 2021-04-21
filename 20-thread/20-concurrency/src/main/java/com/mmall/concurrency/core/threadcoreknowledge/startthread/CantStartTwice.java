package com.mmall.concurrency.core.threadcoreknowledge.startthread;

/**
 * 描述：     演示不能两次调用start方法，否则会报错
 */
public class CantStartTwice {
    public static void main(String[] args) {
        Thread thread = new Thread();
        thread.start();
        thread.start();
    }
}
/* Output:
Exception in thread "main" java.lang.IllegalThreadStateException
	at java.lang.Thread.start(Thread.java:708)
	at com.mmall.concurrency.threadcoreknowledge.core.startthread.CantStartTwice.main(CantStartTwice.java:10)
*///~