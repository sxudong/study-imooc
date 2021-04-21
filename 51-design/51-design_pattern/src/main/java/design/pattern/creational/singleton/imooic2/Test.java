package design.pattern.creational.singleton.imooic2;

/**
 * 单例懒汉模式 —— 延迟初始化方案一
 * 8-3 单例设计模式-DoubleCheck双重检查实战及原理解析
 * 解决隐患重排序：volatie 通过加入“内存屏障”和“禁止重排序”优化来实现可见性。
 */
public class Test {
    public static void main(String[] args) {
        Thread t1 = new Thread(new T());
        Thread t2 = new Thread(new T());
        t1.start();
        t2.start();
        System.out.println("program end");
    }
}
/* Output: 从输出可以看出，两个是同一个对象。
Thread-1  design.pattern.creational.singleton.example2.LazyDoubleCheckSingleton2@2344f617
Thread-0  design.pattern.creational.singleton.example2.LazyDoubleCheckSingleton2@2344f617
program end
 */