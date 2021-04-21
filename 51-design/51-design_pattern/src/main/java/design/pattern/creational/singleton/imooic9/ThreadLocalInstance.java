package design.pattern.creational.singleton.imooic9;

/**
 * 8-10 单例设计模式-ThreadLocal线程单例
 */
public class ThreadLocalInstance {
    // T中声明的一个静态字段被使用，而且这个字段不是一个常量字段。在首次调用时初始化。
    // 《Java 并发编程的艺术》 3.3.4 基于类初始化的解决方案。
    private static final ThreadLocal<ThreadLocalInstance> threadLocalInstanceThreadLocal = new ThreadLocal<ThreadLocalInstance>(){
        @Override
        protected ThreadLocalInstance initialValue() {
            return new ThreadLocalInstance();
        }
    };

    private ThreadLocalInstance(){
    }

    public static ThreadLocalInstance getInstance(){
        return threadLocalInstanceThreadLocal.get();
    }

}
