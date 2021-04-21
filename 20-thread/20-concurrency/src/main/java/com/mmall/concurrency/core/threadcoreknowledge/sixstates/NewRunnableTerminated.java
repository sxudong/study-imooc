package com.mmall.concurrency.core.threadcoreknowledge.sixstates;

/**
 * 6.1-6.5
 * 描述：展示线程的NEW、RUNNABLE、Terminated状态。
 * 即使是正在运行，也是Runnable状态，而不是Running。
 */
public class NewRunnableTerminated implements Runnable {

    public static void main(String[] args) {
        Thread thread = new Thread(new NewRunnableTerminated());
        //打印出NEW的状态
        System.out.println("状态1：" + thread.getState());
        thread.start();
        System.out.println("状态2：" + thread.getState());
        try {
            Thread.sleep(10);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        //打印出RUNNABLE的状态，即使是正在运行，也是RUNNABLE，而不是RUNNING
        System.out.println("状态3：" + thread.getState());
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        //打印出TERMINATED状态
        System.out.println("状态4：" + thread.getState());
    }

    @Override
    public void run() {
        for (int i = 0; i < 1000; i++) {
            System.out.println(i);
        }
    }
}
/* Output:
状态1：NEW
状态2：RUNNABLE
0
1
2
3
. . . . . . .
852
状态3：RUNNABLE
853
. . . . . . .
999
状态4：TERMINATED
 *///~