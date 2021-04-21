package design.pattern.creational.singleton.imooic9;

import design.pattern.creational.singleton.ThreadLocalInstance;

/**
 * 8-10 单例设计模式-ThreadLocal线程单例
 */
public class T implements Runnable {
    @Override
    public void run() {
        ThreadLocalInstance instance = ThreadLocalInstance.getInstance();
        System.out.println(Thread.currentThread().getName() + "  " + instance);
    }
}
