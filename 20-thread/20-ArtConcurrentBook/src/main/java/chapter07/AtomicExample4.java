package chapter07;

import java.util.concurrent.atomic.AtomicReference;


public class AtomicExample4 {

    // AtomicReference 原子的更新引用类型
    private static AtomicReference<Integer> count = new AtomicReference<>(0);

    public static void main(String[] args) {
        count.compareAndSet(0, 2); // 2   原值是：0  要更新的值是：2
        count.compareAndSet(0, 1); // no
        count.compareAndSet(1, 3); // no
        count.compareAndSet(2, 4); // 4   原值是：2  要更新的值是：3
        count.compareAndSet(3, 5); // no

        System.out.println(count.get()); //最终值是：4
    }
}
