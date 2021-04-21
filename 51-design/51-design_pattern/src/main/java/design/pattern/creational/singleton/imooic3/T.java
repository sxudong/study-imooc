package design.pattern.creational.singleton.imooic3;


/**
 * 8-4 单例设计模式-静态内部类-基于类初始化的延迟加载解决方案及原理解析
 */
public class T implements Runnable {
    @Override
    public void run() {
        StaticInnerClassSingleton instance = StaticInnerClassSingleton.getInstance();
        System.out.println(Thread.currentThread().getName()+"  "+instance);
    }
}
