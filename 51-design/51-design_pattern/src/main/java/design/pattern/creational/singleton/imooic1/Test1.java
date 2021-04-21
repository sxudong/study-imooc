package design.pattern.creational.singleton.imooic1;

/**
 * 8-2 单列设计模式 懒汉式及多线程debug
 */
public class Test1 {
    public static void main(String[] args) {
//        LazySingleton lazySingleton = LazySingleton.getInstance();
        Thread t1 = new Thread(new T());
        Thread t2 = new Thread(new T());
        t1.start();
        t2.start();
        System.out.println("program end");
    }
}
/* Output: 从结果看，拿到的是同一个对象，是因为后面那个线程重新赋值了对象，覆盖了前一个线程
program end
Thread-0  design.pattern.creational.singleton.example1.LazySingleton@1dc022f6
Thread-1  design.pattern.creational.singleton.example1.LazySingleton@1dc022f6
 */

// 拿到的对象不一样，debug让Thread-0和Thread-1都到达new LazySingleton()，
// 然后Thread-0先跑完，再让Thread-1跑完，结果就是两个不同的对象了。
/* Output:
program end
Thread-0  design.pattern.creational.singleton.example1.LazySingleton@2df6d0d2
Thread-1  design.pattern.creational.singleton.example1.LazySingleton@35a8db72
 */