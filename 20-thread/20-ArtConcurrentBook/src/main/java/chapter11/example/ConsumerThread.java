package chapter11.example;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.LockSupport;


/**
 * 消费者
 */
public class ConsumerThread implements Runnable {
    private BlockingQueue<String> queue;
    private volatile boolean flag = true;

    public ConsumerThread(BlockingQueue<String> queue) {
        this.queue = queue;
    }

    @Override
    public void run() {
        try {
            System.out.println("消费线程启动...");
            while (flag) {
                System.out.println("消费者正在获取数据...");
                String data = queue.poll(2, TimeUnit.SECONDS);
                if (data != null) {
                    System.out.println("消费者拿到队列中的数据:" + data);
                    Thread.sleep(1000);
                } else {
                    System.out.println("消费者未拿到队列中的数据");
                    flag = false;
                }

            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            System.out.println("消费者结束");
        }
    }
}