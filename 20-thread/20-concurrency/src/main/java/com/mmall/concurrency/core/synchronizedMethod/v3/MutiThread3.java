package com.mmall.concurrency.core.synchronizedMethod.v3;

/**
 * < Java程序员面试笔试-- p156 >
 */
class Test3 {

    Object object = new Object();

    public void synchronizedMethod() {
        // 锁住的是object对象，在线程进入同步块中后，
        // 另一个线程可以执行 generalMethod ()方法
        synchronized(object) {
        //synchronized(this) { // this 是 Test3，锁住的是Test3对象，在线程进入同步块中后，另一个线程不可以执行 generalMethod ()方法
            System.out.println("begin alling synchronizedMethod");
            try {
                /**
                 * 方法内部调用了wait()方法释放对象锁，那么其它线程就
                 * 可以访问同一对象的其它 synchronized() 方法。
                 */
                //wait();
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                System.out.println(e.getMessage());
            }
            System.out.println("finish alling synchronizedMethod");
        }
    }

    //public synchronized static void generalMethod () {
    public synchronized void generalMethod () {
        System.out.println("call generalMethod...");
    }
}

public class MutiThread3 {

    static final Test3 t = new Test3();
    
    public static void main(String[] args) {
        Thread t1 = new Thread() {
            @Override
            public void run() {
                t.synchronizedMethod();
            }
        };

        Thread t2 = new Thread() {
            public void run() {
                t.generalMethod();
            }
        };

        t1.start();
        t2.start();
    }
}
/**
 * 锁住的是object对象，不是整个Test3，所以可以另一个线程可以调用另一个同步方法。
 * 如果用this，则锁住的是整个Test3对象，另一个线程必需要等待synchronizedMethod()
 * 执行完才可以调用执行 generalMethod ()同步方法。
 */
/* Output:
begin alling synchronizedMethod
call generalMethod...
finish alling synchronizedMethod
*///~