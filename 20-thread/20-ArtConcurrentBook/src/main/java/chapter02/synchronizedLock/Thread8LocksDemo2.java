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
 * 本示例实现第3种，和第4种情形
 *     在资源类中添加普通的hello方法
 *     public void hello(){ System.out.println("hello"); }
 *     用 B 线程去调用，运行结果是先打印 “hello”，4秒后发送邮件
 */
class Phone2 {

    public void hello() {
        System.out.println("hello");
    }

    public synchronized void send_email() throws Exception {
        // 邮件方法中暂停 4 秒
        TimeUnit.SECONDS.sleep(4);
        System.out.println("-------send e-mail-----");
    }

    public synchronized void send_message() throws Exception {
        System.out.println("-------send message-----");
    }
}


public class Thread8LocksDemo2 {
    /**
     * 被线程操作的资源类 Phone，包含两个 synchronized 同步方法（发邮件和发短信）
     * main 方法中 new 出一个 Phone 实例对象，并创建 A, B 两个线程去调用phone对象
     */
    public static void main(String[] args) throws InterruptedException {
        Phone2 phone = new Phone2();
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
                phone.hello();
                phone.send_message();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "B").start();
    }
}
/* 可以的得出结论，普通方法的调用与同步锁无关：
Thread A begin start
Thread B begin start
hello
-------send e-mail-----
-------send message-----
 */