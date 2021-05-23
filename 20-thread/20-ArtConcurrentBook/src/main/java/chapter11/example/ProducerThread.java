package chapter11.example;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.LockSupport;


/**
 * 生产者
 */
public class ProducerThread implements Runnable {
    private BlockingQueue queue;
    private volatile boolean flag = true;
    private static AtomicInteger count = new AtomicInteger();

    public ProducerThread(BlockingQueue queue) {
        this.queue = queue;
    }

    @Override
    public void run() {
        try {
            System.out.println("生产线程启动...");
            while (flag) {
                System.out.println("正在生产...");
                String data = count.incrementAndGet() + "";
                boolean offer = queue.offer(data, 2, TimeUnit.SECONDS);
                if (offer) {
                    System.out.println("生产者存入" + data + "到队列成功");
                } else {
                    System.out.println("生产者存入" + data + "到队列失败");
                }
                Thread.sleep(1000);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            System.out.println("生产结束");
        }
    }

    public void stop() {
        this.flag = false;
    }
}