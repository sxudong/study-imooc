package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-4
 */
public class SleepUtils {
    public static final void second(long seconds) {
        try {
            TimeUnit.SECONDS.sleep(seconds);
        } catch (InterruptedException e) {
            System.out.println("抛出 InterruptedException 异常捕获");
        }
    }
}
