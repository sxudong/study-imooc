package chapter02.synchronizedLock;

import java.util.concurrent.TimeUnit;

class Phone3 {

    public synchronized void send_email() throws Exception {
        // 邮件方法中暂停 4 秒
        TimeUnit.SECONDS.sleep(4);
        System.out.println("-------send e-mail-----");
    }

    public synchronized void send_message() throws Exception {
        System.out.println("-------send message-----");
    }
}

public class Thread8LocksDemo3 {

    /**
     * 使用两个 Phone 实例对象
     */
    public static void main(String[] args) throws InterruptedException {
        Phone3 phone1 = new Phone3();
        Phone3 phone2 = new Phone3();

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
     * 用1、2的生活例子帮助理解：
     *     现在我手上有一台iPhone12，阿强手上有一台华为P40，我们各自在自己手机上操作，
     *     不会发生争抢，无论我花多少时间去编辑邮件，都不会影响阿强发短信的行为。
     */
}
/* 当换成两个实例对象之后，运行结果变成先发送短信，4秒后再发送邮件
Thread A begin start
Thread B begin start
-------send message-----
-------send e-mail-----
 */