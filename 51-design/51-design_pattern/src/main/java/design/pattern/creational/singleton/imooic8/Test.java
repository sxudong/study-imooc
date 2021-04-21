package design.pattern.creational.singleton.imooic8;

import java.io.IOException;

/**
 * 8-9 单例设计模式 -- 容器单例
 */
public class Test {
    public static void main(String[] args) throws IOException {
        // 测试线程安全问题
        Thread t1 = new Thread(new T());
        Thread t2 = new Thread(new T());
        t1.start();
        t2.start();
        System.out.println("program end");  // 打断点测试
    }
}
/* Output:
program end
Thread-1  java.lang.Object@20918748
Thread-0  java.lang.Object@20918748
*///~