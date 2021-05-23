package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-15
 * 4.3.6 ThreadLocal的使用
 *
 * 例子中，构建了一个常用的 Profiler 类，它具有 begin() 和 end() 两个方法，而
 * end()方法返回从 begin() 方法调用开始到 end() 方法被调用时的时间差，单位是毫秒。
 */
public class Profiler {
    // 第一次get()方法调用时会进行初始化（如果set方法没有调用），每个线程会调用一次
    private static final ThreadLocal<Long> TIME_THREADLOCAL = new ThreadLocal<Long>() {
        @Override // 初始化值
        protected Long initialValue() {
            return System.currentTimeMillis();
        }
    };

    public static final void begin() {
        TIME_THREADLOCAL.set(System.currentTimeMillis());
    }

    public static final long end() {
        return System.currentTimeMillis() - TIME_THREADLOCAL.get();
    }

    public static void main(String[] args) throws Exception {
        Profiler.begin();
        TimeUnit.SECONDS.sleep(1);
        System.out.println("Cost: " + Profiler.end() + " mills");
    }
}
/* Output:
Cost: 1002 mills
 */