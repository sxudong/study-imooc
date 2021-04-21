package design.pattern.creational.singleton.imooic6;

import design.annoations.ThreadSafe;

/**
 * 8-2 单列设计模式 懒汉式及多线程debug
 */
@ThreadSafe
public class LazySingleton {
    private static LazySingleton lazySingleton = null;

    private LazySingleton() {
        if(lazySingleton != null){
            throw new RuntimeException("单例构造器禁止反射调用");
        }
    }

    public static LazySingleton getInstance(){
        if(lazySingleton == null){
            lazySingleton = new LazySingleton();
        }
        return lazySingleton;
    }
}
