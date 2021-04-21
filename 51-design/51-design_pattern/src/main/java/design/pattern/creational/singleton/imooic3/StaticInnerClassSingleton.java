package design.pattern.creational.singleton.imooic3;

import design.annoations.ThreadSafe;

/**
 * 8-4 单例设计模式—静态内部类 —— 基于类初始化的延迟加载解决方案及原理解析
 * Java 静态内部类的加载时机：https://www.cnblogs.com/zouxiangzhongyan/p/10762540.html
 *
 * 假设一个类是A类，几种情况会导致 A类 会被立即初始化：
 *   1、有一个A类型的实例被创建
 *   2、A类中被声明的一个静态方法被调用
 *   3、A类中被声明的一个静态成员被赋值
 *   4、A类中声明的一个静态成员被使用，并且这个成员不是一个常量成员。
 *   5、A类如果是一个顶级类，而且一个断言语句嵌套在T内部被执行。
 *                ——《Java并发编程的艺术》3.8.4 基于类初始化的解决方案 P72
 */
@ThreadSafe
public class StaticInnerClassSingleton {
    /**
     * 静态内部类
     * “静态内部类”这种方式核心在于InnerClass这个类的对象初始化锁，看哪个线程拿到，哪个线程就去初始化它。
     */
    private static class InnerClass{
        private static StaticInnerClassSingleton staticInnerClassSingleton = new StaticInnerClassSingleton();
    }

    public static StaticInnerClassSingleton getInstance(){
        return InnerClass.staticInnerClassSingleton;
    }

    // 私有构造器
    private StaticInnerClassSingleton(){
        if(InnerClass.staticInnerClassSingleton != null){
            throw new RuntimeException("单例构造器禁止反射调用");
        }
    }
}
