package chapter11.example2;

import java.util.Random;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 生产者 用于提交用户请求，提取用户任务，并装入内存缓冲区
 */
public class Producer implements Runnable{
    private volatile boolean isRunning = true;
    // 共享内存缓存区 缓存生产者提交的任务或数据，供消费者使用
    private BlockingQueue<PCData> queue;
    // 总数
    private static AtomicInteger count = new AtomicInteger();
    private static final int SLEEPTIME = 1000;

    public Producer(BlockingQueue<PCData> queue) {
        this.queue = queue;
    }

    @Override
    public void run() {
        PCData data = null;
        Random r = new Random();
        System.out.println("start Producer id="+Thread.currentThread().getId());
        try {
            while (isRunning){
                Thread.sleep(r.nextInt(SLEEPTIME));
                //构造任务数据
                data = new PCData(count.incrementAndGet());
                System.out.println(data+" is put into queue");
                //提交数据到缓冲区
                if (!queue.offer(data,2, TimeUnit.SECONDS)){
                    System.out.println("failed to put data: " + data);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            Thread.currentThread().interrupt();
        }
    }
    public void stop(){
        isRunning = false;
    }
}