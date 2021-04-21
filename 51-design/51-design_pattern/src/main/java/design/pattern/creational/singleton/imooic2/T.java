package design.pattern.creational.singleton.imooic2;


/**
 * 8-3 单例设计模式-DoubleCheck双重检查实战及原理解析
 */
public class T implements Runnable {
    @Override
    public void run() {
        LazyDoubleCheckSingleton2 instance = LazyDoubleCheckSingleton2.getInstance();
        System.out.println(Thread.currentThread().getName() + "  " + instance);
    }
}
