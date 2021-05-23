package chapter03.volatileexample;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

/**
 * 不保证原子性
 */
public class VolatileDemo2 {
    public static void main(String[] args) throws InterruptedException {
        //原子性的验证
        //使用栅栏保证所有的线程有执行完
        CountDownLatch countDownLatch = new CountDownLatch(100);
        Resource resource = new Resource();
        for (int i = 0; i < 100; i++) {
            new Thread(() -> {
                try {
                    resource.add();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                countDownLatch.countDown();
            }).start();
        }
        countDownLatch.await();
        System.out.println(resource.num);
    }
}

class Resource {
    volatile int num = 0;

    // AtomicInteger atomicInteger = new AtomicInteger(); 使用原子类可以解决
    public void add() throws InterruptedException {
        for (int i = 0; i < 20; i++) {
            TimeUnit.MICROSECONDS.sleep(20);
            num++;
        }
    }
}