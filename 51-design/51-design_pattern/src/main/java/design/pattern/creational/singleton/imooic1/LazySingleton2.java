package design.pattern.creational.singleton.imooic1;

import design.annoations.ThreadSafe;

/**
 * 8-2 单例设计模式 懒汉式改进，添加 synchronized
 * 延迟加载单例模式
 */
@ThreadSafe
public class LazySingleton2 {
    private static LazySingleton2 lazySingleton = null;

    private LazySingleton2() {
    }
    // 添加同步方法，如果锁是添加在静态方法上，相当于锁的是这个类的class文件，
    // 如果不是静态方法，那么锁的是堆内存中生成的对象
    public synchronized static LazySingleton2 getInstance(){
        if(lazySingleton == null){
            lazySingleton = new LazySingleton2();
        }
        return lazySingleton;
    }
//    public static LazySingleton2 getInstance(){
//        //锁静态方法的写法，跟现在这个方法是一样的（上面的写法跟下面一样）
//        synchronized(LazySingleton2.class) {
//            if(lazySingleton == null){
//                lazySingleton = new LazySingleton2();
//            }
//            return lazySingleton;
//        }
//    }
}
