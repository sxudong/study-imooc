package chapter07;

import java.util.concurrent.atomic.AtomicReference;

import static java.lang.Thread.sleep;

/**
 * 展示 CAS 中的 ABA 问题
 */
public class AccountABA1 {
    static AtomicReference<String> reference = new AtomicReference<>("A");

    public static void main(String[] args) throws InterruptedException {
        System.out.println(Thread.currentThread().getName() + "start running ...");
        String prev = reference.get();
        other();
        sleep(1000);
        System.out.println(Thread.currentThread().getName() + " change: A -> C : " + reference.compareAndSet(prev, "C"));
    }

    //展示CAS中的ABA问题
    private static void other() throws InterruptedException {
        new Thread(() -> {
            System.out.println("change A -> B : " + reference.compareAndSet(reference.get(), "B"));
        }, "thread1").start();

        sleep(1000);

        new Thread(() -> {
            System.out.println("change B -> A : " + reference.compareAndSet(reference.get(), "A"));
        }, "thread2").start();
    }
}
/* Output:
mainstart running ...
change A -> B : true
change B -> A : true
main change: A -> C : true
 */