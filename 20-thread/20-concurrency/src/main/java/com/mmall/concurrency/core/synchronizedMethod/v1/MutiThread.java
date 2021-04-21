package com.mmall.concurrency.core.synchronizedMethod.v1;

/**
 * < Java程序员面试笔试-- p156 >
 */
class Test{

    public synchronized void synchronizedMethod() {
        System.out.println("begin alling synchronizedMethod");
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
        }
        System.out.println("finish alling synchronizedMethod");
    }

    public synchronized static void generalMethod () {
        System.out.println("call generalMethod...");
    }
}

public class MutiThread {

    static final Test t = new Test();

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

/* Output:
begin alling synchronizedMethod
call generalMethod...
finish alling synchronizedMethod
*///~