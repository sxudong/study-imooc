package com.mmall.concurrency.core.threadcoreknowledge.stopthreads.volatiledemo;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * 描述：     演示用volatile的局限part2 陷入阻塞时，volatile是无法线程的 此例中，生产者的生产速度很快，消费者消费速度慢，所以阻塞队列满了以后，生产者会阻塞，等待消费者进一步消费
 */
public class WrongWayVolatileCantStop {

    public static void main(String[] args) throws InterruptedException {
        ArrayBlockingQueue storage = new ArrayBlockingQueue(10);

        Producer producer = new Producer(storage);
        Thread producerThread = new Thread(producer);
        producerThread.start();
        Thread.sleep(1000);

        Consumer consumer = new Consumer(storage);
        while (consumer.needMoreNums()) {
            System.out.println(consumer.storage.take()+"被消费了");
            Thread.sleep(100);
        }
        System.out.println("消费者不需要更多数据了。");

        //一旦消费不需要更多数据了，我们应该让生产者也停下来，但是实际情况
        producer.canceled=true;
        System.out.println(producer.canceled);
    }
}

class Producer implements Runnable {

    public volatile boolean canceled = false;

    BlockingQueue storage;

    public Producer(BlockingQueue storage) {
        this.storage = storage;
    }


    @Override
    public void run() {
        int num = 0;
        try {
            while (num <= 100000 && !canceled) {
                if (num % 100 == 0) {
                    storage.put(num);
                    System.out.println(num + "是100的倍数,被放到仓库中了。");
                }
                num++;
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            System.out.println("生产者结束运行");
        }
    }
}

class Consumer {

    BlockingQueue storage;

    public Consumer(BlockingQueue storage) {
        this.storage = storage;
    }

    public boolean needMoreNums() {
        if (Math.random() > 0.95) {
            return false;
        }
        return true;
    }
}
/* Output:
0是100的倍数,被放到仓库中了。
100是100的倍数,被放到仓库中了。
200是100的倍数,被放到仓库中了。
300是100的倍数,被放到仓库中了。
400是100的倍数,被放到仓库中了。
500是100的倍数,被放到仓库中了。
600是100的倍数,被放到仓库中了。
700是100的倍数,被放到仓库中了。
800是100的倍数,被放到仓库中了。
900是100的倍数,被放到仓库中了。
1000是100的倍数,被放到仓库中了。
0被消费了
1100是100的倍数,被放到仓库中了。
100被消费了
200被消费了
1200是100的倍数,被放到仓库中了。
300被消费了
1300是100的倍数,被放到仓库中了。
400被消费了
1400是100的倍数,被放到仓库中了。
1500是100的倍数,被放到仓库中了。
500被消费了
1600是100的倍数,被放到仓库中了。
600被消费了
700被消费了
1700是100的倍数,被放到仓库中了。
1800是100的倍数,被放到仓库中了。
800被消费了
900被消费了
1900是100的倍数,被放到仓库中了。
2000是100的倍数,被放到仓库中了。
1000被消费了
1100被消费了
2100是100的倍数,被放到仓库中了。
1200被消费了
2200是100的倍数,被放到仓库中了。
1300被消费了
2300是100的倍数,被放到仓库中了。
1400被消费了
2400是100的倍数,被放到仓库中了。
1500被消费了
2500是100的倍数,被放到仓库中了。
2600是100的倍数,被放到仓库中了。
1600被消费了
1700被消费了
2700是100的倍数,被放到仓库中了。
1800被消费了
2800是100的倍数,被放到仓库中了。
消费者不需要更多数据了。
true
*///~