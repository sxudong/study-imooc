package design.pattern.creational.singleton.imooic9;


/**
 * 8-10 单例设计模式 -- 基于 ThreadLocal 线程单例
 * 这个单例要画一个引号，它不能保证这个单例全局唯一，它可以保护线程唯一。
 */
public class Test {
    public static void main(String[] args) {
        System.out.println("main thread"+ThreadLocalInstance.getInstance());
        System.out.println("main thread"+ThreadLocalInstance.getInstance());
        System.out.println("main thread"+ThreadLocalInstance.getInstance());
        System.out.println("main thread"+ThreadLocalInstance.getInstance());
        System.out.println("main thread"+ThreadLocalInstance.getInstance());
        System.out.println("main thread"+ThreadLocalInstance.getInstance());

        Thread t1 = new Thread(new T());
        Thread t2 = new Thread(new T());
        t1.start();
        t2.start();
        System.out.println("program end");

    }
}
/* Output:
main threadcom.geely.design.pattern.creational.singleton.imooic9.ThreadLocalInstance@2dda6444 // main线程，拿到的都是同一个
main threadcom.geely.design.pattern.creational.singleton.imooic9.ThreadLocalInstance@2dda6444
main threadcom.geely.design.pattern.creational.singleton.imooic9.ThreadLocalInstance@2dda6444
main threadcom.geely.design.pattern.creational.singleton.imooic9.ThreadLocalInstance@2dda6444
main threadcom.geely.design.pattern.creational.singleton.imooic9.ThreadLocalInstance@2dda6444
main threadcom.geely.design.pattern.creational.singleton.imooic9.ThreadLocalInstance@2dda6444
program end
Thread-1  design.pattern.creational.singleton.ThreadLocalInstance@1fad1580  //这两个线程拿到的对象并不是同一个
Thread-0  design.pattern.creational.singleton.ThreadLocalInstance@3d6741a8
 */