package com.mmall.concurrency.example.syncContainer;

import com.mmall.concurrency.annoations.NotThreadSafe;

import java.util.Vector;

/**
 * 6-7 同步容器Vector
 * Vector在某些情况下会出现线程不安全
 *
 * 演示了同步容器中因为操作顺序的差异，不同的线程里面，
 * 它们可能会触发线程不安全问题。因此必须在访问调用端
 * 做一些额外的措施才可以。
 */
@NotThreadSafe
public class VectorExample2 {

    private static Vector<Integer> vector = new Vector<>();

    public static void main(String[] args) {

        while (true) {

            for (int i = 0; i < 10; i++) {
                vector.add(i);
            }

            /**
             * vector虽然保证同一时刻只有一个线程访问它，
             * 不排除当某个线程某个时刻执行vector.get(i)的时候，
             * vector.size()返回的是10，i=9,而另外一个线程执行
             * 到了vector.remove(i)，它下好将9给移除掉了，这个时候
             * vector.get(i)方法调下标为9的元素就会出现数组越界异常。
             */
            Thread thread1 = new Thread() {
                public void run() {
                    for (int i = 0; i < vector.size(); i++) {
                        vector.remove(i);
                    }
                }
            };

            Thread thread2 = new Thread() {
                public void run() {
                    for (int i = 0; i < vector.size(); i++) {
                        // 抛出异常，数组越界 Array index out of range: 8
                        // get越界是remove引起的
                        vector.get(i);
                    }
                }
            };
            thread1.start();
            thread2.start();
        }
    }
}
