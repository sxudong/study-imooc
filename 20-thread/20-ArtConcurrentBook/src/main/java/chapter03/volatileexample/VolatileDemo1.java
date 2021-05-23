package chapter03.volatileexample;

import java.util.concurrent.TimeUnit;

/**
 * 保证可见性
 */
public class VolatileDemo1 {
    private static volatile Boolean flag = true;

    public static void main(String[] args) {
        new Thread(() -> {
            while (flag) {

            }
        }).start();

        new Thread(() -> {
            try {
                TimeUnit.SECONDS.sleep(2);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            flag = false;
            System.out.println("修改了flag的值");
        }).start();
    }
}