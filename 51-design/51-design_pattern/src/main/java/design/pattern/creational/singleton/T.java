package design.pattern.creational.singleton;

/**
 * Created by geely
 */
public class T implements Runnable {
    @Override
    public void run() {
        // 8-2 单列设计模式 懒汉式及多线程debug
//        LazySingleton lazySingleton = LazySingleton.getInstance();
//        System.out.println(Thread.currentThread().getName() + "  " + lazySingleton);

        // 8-3 单例设计模式-DoubleCheck双重检查实战及原理解析
//        LazyDoubleCheckSingleton instance = LazyDoubleCheckSingleton.getInstance();
//        System.out.println(Thread.currentThread().getName()+"  "+instance);

        // 8-4 单例设计模式-静态内部类-基于类初始化的延迟加载解决方案及原理解析
//        StaticInnerClassSingleton instance = StaticInnerClassSingleton.getInstance();
//        System.out.println(Thread.currentThread().getName()+"  "+instance);

        // 8-9 单例设计模式-容器单例
//        ContainerSingleton.putInstance("object",new Object());
//        Object instance = ContainerSingleton.getInstance("object");
//        System.out.println(Thread.currentThread().getName()+"  "+instance);

        // 8-10 单例设计模式-ThreadLocal线程单例
        ThreadLocalInstance instance = ThreadLocalInstance.getInstance();
        System.out.println(Thread.currentThread().getName()+"  "+instance);

    }
}
