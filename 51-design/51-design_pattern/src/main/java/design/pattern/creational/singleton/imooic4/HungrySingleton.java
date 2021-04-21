package design.pattern.creational.singleton.imooic4;

import java.io.Serializable;

/**
 * 8-5 单例设计模式-饿汉式
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

    public void print() {
        System.out.println("Hello World!");
    }

    public static void main(String[] args) {
        HungrySingleton instance = HungrySingleton.getInstance();
        instance.print();
    }
}
