package design.pattern.creational.singleton.imooic6;

import java.io.Serializable;

/**
 * 单例设计模式-饿汉式
 * 8-7 单例设计模式 -- 反射攻击解决方案及原理分析
 */
public class HungrySingleton implements Serializable, Cloneable{
    // 不用静态块，直接使用这个静态字段会导致初始化
    // 《Java编程的艺术》3.8.4 基于类初始化的解决方案
    private final static HungrySingleton hungrySingleton;

    static{
        hungrySingleton = new HungrySingleton();
    }

    private HungrySingleton(){
        if(hungrySingleton != null){
            throw new RuntimeException("单例构造器禁止反射调用");
        }
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

    // 单例要么不要实现Cloneable克隆，实现了就返回getInstance()
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return getInstance();
    }
}
