package com.mmall.concurrency.core.threadcoreknowledge.stopthreads;

public class RightWayStopThreadInProd implements Runnable {

    @Override
    public void run() {
        while (true && !Thread.currentThread().isInterrupted()) {
            System.out.println("go");
            try {
                throwInMethod();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                //保存日志、停止程序
                System.out.println("保存日志");
                e.printStackTrace();
            }
        }
    }

    private void throwInMethod() throws InterruptedException {
        Thread.sleep(2000);
    }

    public static void main(String[] args) throws InterruptedException {
        Thread thread = new Thread(new RightWayStopThreadInProd());
        thread.start();
        Thread.sleep(1000);
        thread.interrupt();
    }
}
/* Output:
go
保存日志
java.lang.InterruptedException: sleep interrupted
	at java.lang.Thread.sleep(Native Method)
	at com.mmall.concurrency.core.threadcoreknowledge.stopthreads.RightWayStopThreadInProd.throwInMethod(RightWayStopThreadInProd.java:21)
	at com.mmall.concurrency.core.threadcoreknowledge.stopthreads.RightWayStopThreadInProd.run(RightWayStopThreadInProd.java:10)
	at java.lang.Thread.run(Thread.java:748)
*///~