package chapter03;

import java.util.concurrent.CountDownLatch;

class VolatileFeaturesExample {
    volatile long vl = 0L; //使用volatile声明64位的long型变量

    public void set(long l) {
        vl = l; //单个volatile变量的写
    }

    public void getAndIncrement() {
        vl++; //复合（多个）volatile变量的读/写
    }

    public long get() {
        return vl; //单个volatile变量的读
    }

    public static void main(String[] args) {
        CountDownLatch count = new CountDownLatch(10);
        VolatileFeaturesExample e = new VolatileFeaturesExample();
        // 10 * 1000
        for (int i = 0; i < 10; i++) {
            Thread thread = new Thread(new Mythread(e, count));
            thread.start();
        }
        try {
            count.await();
        } catch (InterruptedException e1) {
            e1.printStackTrace();
        }
        System.out.println("result: " + e.get());
    }
}

class Mythread implements Runnable {
    VolatileFeaturesExample e;
    CountDownLatch countDownLatch;
    // 0, 10
    public Mythread(VolatileFeaturesExample e, CountDownLatch countDownLatch) {
        this.e = e;
        this.countDownLatch = countDownLatch;
    }

    @Override
    public void run() {
        for (int i = 0; i < 1000; i++) {
            e.getAndIncrement();
        }
        countDownLatch.countDown();
    }
}