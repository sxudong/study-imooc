package chapter11.example2;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * 使用生产者和消费者的客户端
 */
public class Main {
    public static void main(String[] args) throws InterruptedException {
        //建立缓冲区
        BlockingQueue<PCData> q = new LinkedBlockingQueue<>();
        //建立生产者
        Producer p1 = new Producer(q);
        Producer p2 = new Producer(q);
        Producer p3 = new Producer(q);

        //建立消费者
        Consumer c1 = new Consumer(q);
        Consumer c2 = new Consumer(q);
        Consumer c3 = new Consumer(q);

        //建立线程池
        ExecutorService service = Executors.newCachedThreadPool();
        service.execute(p1);
        service.execute(p2);
        service.execute(p3);
        service.execute(c1);
        service.execute(c2);
        service.execute(c3);
        Thread.sleep(10000);

        //停止生产者
        p1.stop();
        p2.stop();
        p3.stop();
        Thread.sleep(3000);
        service.shutdown();
    }
}