package com.mmall.concurrency.core.threadcoreknowledge.stopthreads.volatiledemo;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * 5.1-5.10 （下）
 * 描述：用中断来修复刚才的无尽等待问题
 */
public class WrongWayVolatileFixed {

    public static void main(String[] args) throws InterruptedException {
        WrongWayVolatileFixed body = new WrongWayVolatileFixed();
        ArrayBlockingQueue storage = new ArrayBlockingQueue(10);

        Producer producer = body.new Producer(storage);
        Thread producerThread = new Thread(producer);
        producerThread.start();
        Thread.sleep(1000);

        Consumer consumer = body.new Consumer(storage);
        while (consumer.needMoreNums()) {
            System.out.println(consumer.storage.take() + "被消费了");
            Thread.sleep(100);
        }
        System.out.println("消费者不需要更多数据了。");


        producerThread.interrupt();
    }

    // 生产者
    class Producer implements Runnable {

        BlockingQueue storage;

        public Producer(BlockingQueue storage) {
            this.storage = storage;
        }

        @Override
        public void run() {
            int num = 0;
            try {
                while (num <= 100000 && !Thread.currentThread().isInterrupted()) {
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

    // 消费者
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
0被消费了
1000是100的倍数,被放到仓库中了。
100被消费了
1100是100的倍数,被放到仓库中了。
200被消费了
1200是100的倍数,被放到仓库中了。
300被消费了
1300是100的倍数,被放到仓库中了。
400被消费了
1400是100的倍数,被放到仓库中了。
500被消费了
1500是100的倍数,被放到仓库中了。
1600是100的倍数,被放到仓库中了。
600被消费了
1700是100的倍数,被放到仓库中了。
700被消费了
1800是100的倍数,被放到仓库中了。
800被消费了
1900是100的倍数,被放到仓库中了。
900被消费了
2000是100的倍数,被放到仓库中了。
1000被消费了
2100是100的倍数,被放到仓库中了。
1100被消费了
2200是100的倍数,被放到仓库中了。
1200被消费了
1300被消费了
2300是100的倍数,被放到仓库中了。
1400被消费了
2400是100的倍数,被放到仓库中了。
1500被消费了
2500是100的倍数,被放到仓库中了。
1600被消费了
2600是100的倍数,被放到仓库中了。
2700是100的倍数,被放到仓库中了。
1700被消费了
1800被消费了
2800是100的倍数,被放到仓库中了。
1900被消费了
2900是100的倍数,被放到仓库中了。
消费者不需要更多数据了。
生产者结束运行
java.lang.InterruptedException
	at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.reportInterruptAfterWait(AbstractQueuedSynchronizer.java:2014)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(AbstractQueuedSynchronizer.java:2048)
	at java.util.concurrent.ArrayBlockingQueue.put(ArrayBlockingQueue.java:353)
	at com.mmall.concurrency.core.threadPool.WrongWayVolatileFixed$Producer.run(WrongWayVolatileFixed.java:47)
	at java.lang.Thread.run(Thread.java:748)
*///~