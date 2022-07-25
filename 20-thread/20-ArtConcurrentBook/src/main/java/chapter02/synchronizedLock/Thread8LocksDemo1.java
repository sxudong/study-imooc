package chapter02.synchronizedLock;

import java.util.concurrent.TimeUnit;
/**
 * 8锁问题分析，以下八种情形：
 *   1.标准访问，先发送邮件还是短信
 *   2.在邮件方法内暂停4秒，先发送邮件还是短信
 *   3.新增普通的 hello 方法，先打印 hello 还是先发送邮件
 *   4.现有两个手机实例对象，先打印短信还是先发送邮件
 *   5.2个静态同步方法，一个手机实例，先发短信还是先发邮件
 *   6.2个静态同步方法，两个手机实例，先发短信还是先发邮件
 *   7.1个静态同步方法，1个普通同步方法，一个手机实例，先发短信还是先发邮件
 *   8.1个静态同步方法，1个普通同步方法，两个手机实例，先发短信还是先发邮件
 *
 * 本示例实现第1种，和第2种情形
 *
 * 原文链接：https://blog.csdn.net/weixin_44868739/article/details/114868470
 */
class Phone {

    public synchronized void send_email() throws Exception {
        // 邮件方法中暂停 4 秒
        TimeUnit.SECONDS.sleep(4);
        System.out.println("-------send e-mail-----");
    }

    public synchronized void send_message() throws Exception {
        System.out.println("-------send message-----");
    }
}

public class Thread8LocksDemo1 {
    /**
     * 被线程操作的资源类 Phone，包含两个 synchronized 同步方法（发邮件和发短信）
     * main 方法中 new 出一个 Phone 实例对象，并创建 A, B 两个线程去调用phone对象
     */
    public static void main(String[] args) throws InterruptedException {
        Phone phone = new Phone();
        System.out.println("Thread A begin start");
        new Thread(() -> {
            try {
                phone.send_email();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "A").start();

        Thread.sleep(100);
        System.out.println("Thread B begin start");

        new Thread(() -> {
            try {
                phone.send_message();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "B").start();
    }
    /* 从结果可以看出：
     * 运行结果仍然是先发送邮件再发送短信，并且在打印之前等待了4秒
     *
     * 可以推断，一个对象里面如果有多个 synchronized 方法，在某一时刻只要有一个线程去访问其中一个
     * 同步方法，其他线程都只能等待，即 某一时刻内，只能有唯一一个线程去访问这些 synchronized 方法。
     * 也就是说 synchronized 锁的是整个 phone实例对象，而不是其中一个方法。
     *
     * 可以用生活中的案例帮助记忆：
     *     现在只有一台iphone12，我要用它发邮件，阿强要用它来发短信，现在我先拿到手机，阿强只能等
     *     我编辑发送完邮件，把手机传给他，才能进行操作，而不可以同时进行。
     */
}
/* Output:
Thread A begin start
Thread B begin start
-------send e-mail-----
-------send message-----
 */
