package design.pattern.creational.singleton.imooic3;

/**
 * 单例懒汉模式 —— 延迟初始化方案二
 * 8-4 单例设计模式—静态内部类 —— 基于类初始化的延迟加载解决方案及原理解析
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
Thread-1  design.pattern.creational.singleton.example3.StaticInnerClassSingleton@39160210
Thread-0  design.pattern.creational.singleton.example3.StaticInnerClassSingleton@39160210
program end
 */