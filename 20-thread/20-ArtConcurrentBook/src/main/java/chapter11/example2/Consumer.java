package chapter11.example2;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.TimeUnit;


import java.text.MessageFormat;
import java.util.Random;
import java.util.concurrent.BlockingQueue;

/**
 * 消费者 在内存缓冲区中提取处理任务
 * poll -->【若队列为空，返回null】
 * remove >【若队列为空，抛出NoSuchElementException异常】
 * take -->【若队列为空，发生阻塞，等待有元素】
 */
public class Consumer implements Runnable{
    private BlockingQueue<PCData> queue;
    private static final int SLEEPTIME = 1000;

    public Consumer(BlockingQueue<PCData> queue) {
        this.queue = queue;
    }

    @Override
    public void run() {
        Random r = new Random();
        System.out.println("start Consumer id="+Thread.currentThread().getId());
        try {
            while (true){
                PCData data = queue.take();//提取任务
                int re = data.getData()*data.getData(); //计算平方
                System.out.println(MessageFormat.format("{0}*{1}={2}"
                        ,data.getData(),data.getData(),re));
                Thread.sleep(r.nextInt(SLEEPTIME));
            }
        } catch (Exception e) {
            e.printStackTrace();
            Thread.currentThread().interrupt();
        }
    }
}