package com.mmall.concurrency.example.singleton;

import com.mmall.concurrency.annoations.NotThreadSafe;

/**
 * 5-2
 * 懒汉模式
 * 单例实例在第一次使用时进行创建
 */
@NotThreadSafe // 线程不安全的
public class SingletonExample1 {

    // 私有构造函数
    private SingletonExample1() {

    }

    // 单例对象
    private static SingletonExample1 instance = null;

    // 静态的工厂方法
    public static SingletonExample1 getInstance() {
        // 多线程环境下，两个线程分别都会拿到 instance == null ，都会去做一次实例化
        // 这时候两个线程拿到的实例是不一样的。
        if (instance == null) {
            instance = new SingletonExample1();
        }
        return instance;
    }
}
