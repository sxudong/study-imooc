package chapter03;

import java.util.concurrent.CountDownLatch;

// 线程不安全的
class VolatileFeaturesExample1 {
    long vl = 0L; // 64位的long型普通变量

    public synchronized void set(long l) {//对单个的普通变量的写用同一个锁同步
        vl = l;
    }

    public void getAndIncrement() { //普通方法调用
        long temp = get(); //调用已同步的读方法
        temp += 1L; //普通写操作
        set(temp); //调用已同步的写方法
    }

    public synchronized long get() { //对单个的普通变量的读用同一个锁同步
        return vl;
    }

    public static void main(String[] args) {
        CountDownLatch count = new CountDownLatch(10);
        VolatileFeaturesExample1 e = new VolatileFeaturesExample1();
        // 10 * 1000
        for (int i = 0; i < 10; i++) {
            Thread thread = new Thread(new ThreadTest(e, count));
            thread.start();
        }
        try {
            count.await();
        } catch (InterruptedException e1) {
            e1.printStackTrace();
        }
        System.out.println("result: " + e.get()); // 9143
    }
}

class ThreadTest implements Runnable {
    VolatileFeaturesExample1 e;
    CountDownLatch countDownLatch;
    // 0, 10
    public ThreadTest(VolatileFeaturesExample1 e, CountDownLatch countDownLatch) {
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