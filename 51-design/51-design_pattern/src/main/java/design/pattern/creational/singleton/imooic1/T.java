package design.pattern.creational.singleton.imooic1;

/**
 * Created by geely
 */
public class T implements Runnable {
    @Override
    public void run() {
        LazySingleton lazySingleton = LazySingleton.getInstance();
        System.out.println(Thread.currentThread().getName() + "  " + lazySingleton);
    }
}
