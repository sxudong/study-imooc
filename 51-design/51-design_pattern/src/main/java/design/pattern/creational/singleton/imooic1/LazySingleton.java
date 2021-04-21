package design.pattern.creational.singleton.imooic1;

import design.annoations.NotThreadSafe;

/**
 * 8-2 单列设计模式 懒汉式及多线程debug
 */
@NotThreadSafe
public class LazySingleton {
    private static LazySingleton lazySingleton = null;

    private LazySingleton() {
    }
    public static LazySingleton getInstance(){
        if(lazySingleton == null){
            lazySingleton = new LazySingleton();
        }
        return lazySingleton;
    }

//    public static void main(String[] args) {
//        LazySingleton lazySingleton = LazySingleton.getInstance();
//        System.out.println("program end");
//    }
}
