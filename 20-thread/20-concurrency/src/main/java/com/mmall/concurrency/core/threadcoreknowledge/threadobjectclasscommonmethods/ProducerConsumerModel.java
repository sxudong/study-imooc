package com.mmall.concurrency.core.threadcoreknowledge.threadobjectclasscommonmethods;

import java.util.Date;
import java.util.LinkedList;

/**
 * 7.1-7.15
 * 描述：用wait/notify来实现生产者消费者模式
 */
public class ProducerConsumerModel {
    public static void main(String[] args) {
        EventStorage eventStorage = new EventStorage();
        Producer producer = new Producer(eventStorage);
        Consumer consumer = new Consumer(eventStorage);
        new Thread(producer).start();
        new Thread(consumer).start();
    }
}

// 生产者
class Producer implements Runnable {

    private EventStorage storage;

    public Producer(EventStorage storage) {
        this.storage = storage;
    }

    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            storage.put();
        }
    }
}

// 消费者
class Consumer implements Runnable {

    private EventStorage storage;

    public Consumer(
            EventStorage storage) {
        this.storage = storage;
    }

    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            storage.take();
        }
    }
}

// 仓库
class EventStorage {

    private int maxSize;
    private LinkedList<Date> storage;

    public EventStorage() {
        maxSize = 10;
        storage = new LinkedList<>();
    }

    public synchronized void put() {
        while (storage.size() == maxSize) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        storage.add(new Date());
        System.out.println("仓库里有了" + storage.size() + "个产品。");
        notify();
    }

    public synchronized void take() {
        while (storage.size() == 0) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("拿到了" + storage.poll() + "，现在仓库还剩下" + storage.size());
        notify();
    }
}
/* Output:
仓库里有了1个产品。
仓库里有了2个产品。
仓库里有了3个产品。
仓库里有了4个产品。
仓库里有了5个产品。
仓库里有了6个产品。
仓库里有了7个产品。
仓库里有了8个产品。
仓库里有了9个产品。
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下8
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下7
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下6
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下5
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下4
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下3
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下2
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下1
拿到了Sat Apr 18 22:12:36 CST 2020，现在仓库还剩下0
*///~


