package design.pattern.creational.singleton.imooic1;

/**
 * 8-2 单列设计模式 懒汉式及多线程debug
 *
 * 同步锁比较消耗资源，这里面有开锁和加锁的开销，
 * 而且 synchronized 用在static修饰的方法上面，
 * 锁的是这个类的class文件，范围比较大，对性能
 * 有一定的影响。
 */
public class Test2 {
    public static void main(String[] args) {
        Thread t1 = new Thread(new T2());
        Thread t2 = new Thread(new T2());
        t1.start();
        t2.start();
        System.out.println("program end");
    }
}
/* Output: 从结果上看，是同一个对象，synchronized 起到了作用
Thread-0  design.pattern.creational.singleton.example1.LazySingleton2@18b58f3b
Thread-1  design.pattern.creational.singleton.example1.LazySingleton2@18b58f3b
program end
 */