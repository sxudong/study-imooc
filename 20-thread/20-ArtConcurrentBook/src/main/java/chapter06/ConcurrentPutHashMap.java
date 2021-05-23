package chapter06;

import java.util.HashMap;
import java.util.UUID;

/**
 * 线程不安全的 HashMap
 * 
 * 在多线程环境下，使用HashMap进行put操作会引起死循环，导致CPU利用率接近100%，所
 * 以在并发情况下不能使用HashMap。例如，执行以下代码会引起死循环。
 */
public class ConcurrentPutHashMap {

    public static void main(String[] args) throws InterruptedException {
        final HashMap<String, String> map = new HashMap<String, String>(2);
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < 10000; i++) {
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            map.put(UUID.randomUUID().toString(), "");
                        }
                    }, "ftf" + i).start();
                }
            }
        }, "ftf");
        t.start();
        t.join();
    }

}
