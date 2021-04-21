package com.mmall.concurrency.core.threadcoreknowledge.stopthreads.volatiledemo;

/**
 * 描述：     演示用volatile的局限：part1 看似可行
 */
public class WrongWayVolatile implements Runnable {

    private volatile boolean canceled = false;

    @Override
    public void run() {
        int num = 0;
        try {
            while (num <= 100000 && !canceled) {
                if (num % 100 == 0) {
                    System.out.println(num + "是100的倍数。");
                }
                num++;
                Thread.sleep(1);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws InterruptedException {
        WrongWayVolatile r = new WrongWayVolatile();
        Thread thread = new Thread(r);
        thread.start();
        Thread.sleep(5000);
        r.canceled = true;
    }
}
/* Output:
0是100的倍数。
100是100的倍数。
200是100的倍数。
300是100的倍数。
400是100的倍数。
500是100的倍数。
600是100的倍数。
700是100的倍数。
800是100的倍数。
900是100的倍数。
1000是100的倍数。
1100是100的倍数。
1200是100的倍数。
1300是100的倍数。
1400是100的倍数。
1500是100的倍数。
1600是100的倍数。
1700是100的倍数。
1800是100的倍数。
1900是100的倍数。
2000是100的倍数。
2100是100的倍数。
2200是100的倍数。
2300是100的倍数。
2400是100的倍数。
2500是100的倍数。
*///~
