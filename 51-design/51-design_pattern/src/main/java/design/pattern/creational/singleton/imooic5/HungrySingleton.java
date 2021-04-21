package design.pattern.creational.singleton.imooic5;

import java.io.Serializable;

/**
 * 单例设计模式-饿汉式
 * 8-6 单例设计模式 -- 序列化破坏单例模式原理解析及解决方案
 */
public class HungrySingleton implements Serializable, Cloneable{
    // 不用静态块，直接使用这个静态字段会导致初始化
    // 《Java编程的艺术》3.8.4 基于类初始化的解决方案
    private final static HungrySingleton hungrySingleton;

    static{
        hungrySingleton = new HungrySingleton();
    }

    public static HungrySingleton getInstance(){
        return hungrySingleton;
    }

    /**
     * 防止因反序列化而重新创建了对象
     */
    private Object readResolve(){
        return hungrySingleton;
    }
}
