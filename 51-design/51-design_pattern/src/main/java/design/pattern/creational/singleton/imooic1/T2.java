package design.pattern.creational.singleton.imooic1;

/**
 * Created by geely
 */
public class T2 implements Runnable {
    @Override
    public void run() {
        LazySingleton2 lazySingleton2 = LazySingleton2.getInstance();
        System.out.println(Thread.currentThread().getName() + "  " + lazySingleton2);
    }
}
