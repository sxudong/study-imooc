package chapter03;

// 饿汉模式
public class Singleton{
    // Singleton类初始化是线程安全的且只初始化一次，保证instance只有一个
    // 声明的一个静态字段被使用，而且这个字段不是一个常量字段。
    private static Singleton instance = new Singleton();

    private Singleton() {
    }

    public static Singleton getInstance(){
        return instance;
    }
}