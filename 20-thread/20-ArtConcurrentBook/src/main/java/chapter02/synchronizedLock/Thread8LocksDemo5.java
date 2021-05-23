package chapter02.synchronizedLock;

import java.util.concurrent.*;

/**
 * 8锁问题分析，以下八种情形：
 *   1.标准访问，先发送邮件还是短信
 *   2.在邮件方法内暂停4秒，先发送邮件还是短信
 *   3.新增普通的hello方法，先打印hello还是先发送邮件
 *   4.现有两个手机实例对象，先打印短信还是先发送邮件
 *   5.2个静态同步方法，一个手机实例，先发短信还是先发邮件
 *   6.2个静态同步方法，两个手机实例，先发短信还是先发邮件
 *   7.1个静态同步方法，1个普通同步方法，一个手机实例，先发短信还是先发邮件
 *   8.1个静态同步方法，1个普通同步方法，两个手机实例，先发短信还是先发邮件
 *
 * 本示例实现第7种，和第8种情形
 *     发送邮件方法为静态同步方法，发短信为 非静态（普通）同步方法
 */
class Phone5 {

    public static synchronized void send_email() throws Exception {
        // 邮件方法中暂停 4 秒
        TimeUnit.SECONDS.sleep(4);
        System.out.println("-------send e-mail-----");
    }

    public synchronized void send_message() throws Exception {
        System.out.println("-------send message-----");
    }
}

public class Thread8LocksDemo5 {

    /**
     * 总结:
     *   synchronized实现同步的基础：Java中每一个对象都可以作为锁
     *   对于普通同步方法（synchronized），锁是当前的实例对象
     *   对于静态同步方法（static synchronized），锁是当前类的 Class 对象
     *   对于同步代码块，锁是 synchronized 括号里配置的对象
     *   不同锁对象之间不存在争抢竞态关系。
     *
     * 原文链接：https://blog.csdn.net/weixin_44868739/article/details/114868470
     */
    public static void main(String[] args) throws InterruptedException {
        Phone5 phone = new Phone5();

        System.out.println("Thread A begin start");
        new Thread(() -> {
            try {
                phone.send_email(); //不同的实例对象
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "A").start();

        Thread.sleep(100);

        System.out.println("Thread B begin start");
        new Thread(() -> {
            try {
                phone.send_message(); //不同的实例对象
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "B").start();
    }
    /*
     * 运行结果都是先发送短信，4秒后发送邮件
     *
     * 原理：
     *    由于非静态同步方法的锁是实例对象本身，而所有静态同步方法用的锁是类模板对象，
     *    这两把锁是两个不同的对象，所以静态同步方法与非静态同步方法之间是不会有竞争
     *    关系的。因此发送短信可以直接执行，无需等待发邮件的方法释放锁。
     */
}
/*
同一个实例：
Thread A begin start
Thread B begin start
-------send message-----
-------send e-mail-----

两个实例：
Thread A begin start
Thread B begin start
-------send message-----
-------send e-mail-----
 */