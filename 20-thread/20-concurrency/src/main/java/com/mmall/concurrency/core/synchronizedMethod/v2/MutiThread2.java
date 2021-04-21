package com.mmall.concurrency.core.synchronizedMethod.v2;

/**
 * < Java程序员面试笔试-- p156 >
 */
class Test2 {

    public synchronized void synchronizedMethod() {
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

    //public synchronized static void generalMethod () {
    public synchronized void generalMethod () {
        System.out.println("call generalMethod...");
    }
}

public class MutiThread2 {

    static final Test2 t = new Test2();
    
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
 * synchronizedMethod() 方法内部没有调用wait()方法，其它方法都为 synchronized() 方法,
 * 那么其它线程将无法访问这个对象的其他方法，此例中必需要等到sleep(5000)睡眠完5秒之后，
 * 执行完整个方法后，其它 synchronized() 方法才可以执行。
 */
/* Output:
begin alling synchronizedMethod
finish alling synchronizedMethod
call generalMethod...
*///~