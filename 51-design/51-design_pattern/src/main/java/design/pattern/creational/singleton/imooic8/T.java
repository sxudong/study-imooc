package design.pattern.creational.singleton.imooic8;


/**
 * 8-9 单例设计模式 -- 容器单例
 */
public class T implements Runnable {
    @Override
    public void run() {
        ContainerSingleton.putInstance("object", new Object());
        Object instance = ContainerSingleton.getInstance("object");
        System.out.println(Thread.currentThread().getName() + "  " + instance);
    }
}
