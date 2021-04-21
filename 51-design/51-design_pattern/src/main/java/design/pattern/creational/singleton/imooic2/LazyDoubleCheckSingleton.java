package design.pattern.creational.singleton.imooic2;

import design.annoations.NotThreadSafe;

/**
 * 8-3 Double Check Lock，双重检查加锁实战及原理解析 —— 多线程下的重排序隐患
 * 关注的是双重检查，这种方式兼顾了性能和线程安全。
 */
@NotThreadSafe
public class LazyDoubleCheckSingleton {
    private static LazyDoubleCheckSingleton lazyDoubleCheckSingleton = null;
    private LazyDoubleCheckSingleton(){
    }

    public static LazyDoubleCheckSingleton getInstance(){
        // 隐患，虽然在这里判断了对象是不是空？这个时候是有可能它不为空的，
        // 但是这个对象还没有完成初始化，也就是说 new LazyDoubleCheckSingleton(); 还没有执行完成
        if(lazyDoubleCheckSingleton == null){
            synchronized (LazyDoubleCheckSingleton.class){
                if(lazyDoubleCheckSingleton == null){
                    //当把对象new出来，看上去是一行，实际上这里面经历了3个步骤，
                    //第2步和第3步的顺序有可能被重排序颠倒
                    lazyDoubleCheckSingleton = new LazyDoubleCheckSingleton();
                    //1.分配内存给这个对象
//                  //3.设置 lazyDoubleCheckSingleton 指向刚分配的内存地址 //这里已经指向了内存地此，所以第15行判断并不为空。如果两个线程，“线程0”执行第3步指向内存空间，此时“线程1”进来判断不为空，就早于“线程0”访问了对象，“线程1”访问的对象是一个在“线程0”中还没有初始化完的对象。参考图
                    //2.初始化对象
//                    intra-thread semantics  // 单线程内，2和3互换位置不会改变程序的执行结果
//                    ---------------//3.设置lazyDoubleCheckSingleton 指向刚分配的内存地址
                }
            }
        }
        return lazyDoubleCheckSingleton;
    }
}
