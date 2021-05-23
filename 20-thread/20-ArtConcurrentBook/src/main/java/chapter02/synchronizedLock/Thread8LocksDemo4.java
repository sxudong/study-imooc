package chapter02.synchronizedLock;

import java.util.concurrent.TimeUnit;

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
 * 本示例实现第5种，和第6种情形
 *     把资源类中的方法加上 static 关键字，变成静态同步方法。
 */
class Phone4 {

    public static synchronized void send_email() throws Exception {
        // 邮件方法中暂停 4 秒
        TimeUnit.SECONDS.sleep(4);
        System.out.println("-------send e-mail-----");
    }

    public static synchronized void send_message() throws Exception {
        System.out.println("-------send message-----");
    }
}

public class Thread8LocksDemo4 {
    /**
     * 使用两个 Phone 实例对象
     */
    public static void main(String[] args) throws InterruptedException {
        Phone4 phone1 = new Phone4();
        Phone4 phone2 = new Phone4();

        System.out.println("Thread A begin start");
        new Thread(() -> {
            try {
                phone1.send_email(); //不同的实例对象
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "A").start();

        Thread.sleep(100);

        System.out.println("Thread B begin start");
        new Thread(() -> {
            try {
                phone2.send_message(); //不同的实例对象
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "B").start();
    }
    /*
     * 由于加上了 static 关键字，变成静态同步方法，所有的静态同步方法用的同一把锁，
     * 是 class 类模板对象本身，根据JVM的类加载器工作原理，把 .class文件 加载并初
     * 始化到内存的 Class 类模板对象只有一份，所以，不管是不是同一个实例，只要他们
     * 是同一个类的实例对象，一旦一个静态同步方法获取锁后，其他的静态同步方法都必
     * 须等待该方法释放锁后才能获得。
     */
}
/* 当换成两个实例对象之后，运行结果变成先发送短信，4秒后再发送邮件
Thread A begin start
Thread B begin start
-------send e-mail-----
-------send message-----
 */