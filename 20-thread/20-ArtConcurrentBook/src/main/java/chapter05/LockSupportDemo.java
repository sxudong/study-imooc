package chapter05;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.LockSupport;


/**
 * 5.5 LockSupport工具测试
 */
public class LockSupportDemo<T> {
    public static void main(String[] args) {
        Thread thread = new Thread(() -> {
            for (int i = 0; i < 10; i++) {
                System.out.println(i);
                if (i == 5) LockSupport.park();
            }
        });
        thread.start();

        try {
            TimeUnit.SECONDS.sleep(2);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("2秒结束 唤醒接续");
        //这边唤醒，LockSupport.park()那边立即返回执行
        LockSupport.unpark(thread);
    }
}
/*
0
1
2
3
4
5
2秒结束 唤醒接续
6
7
8
9
 */