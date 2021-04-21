package com.mmall.concurrency.example.syncContainer;

import java.util.Iterator;
import java.util.Vector;

/**
 * 6-8 同步容器 Vector
 * 如果使用了foreach和iterator循环不要使用remove相应更新操作，
 * 如果需要删除值，在遍历完之后再去执行相关的remove操作。
 */
public class VectorExample3 {

    // 方法运行抛出异常：java.util.ConcurrentModificationException
    private static void test1(Vector<Integer> v1) { // foreach
        for(Integer i : v1) {
            //如果值是3，做remove操作
            if (i.equals(3)) {
                v1.remove(i);
            }
        }
    }

    // 方法运行抛出异常：java.util.ConcurrentModificationException
    private static void test2(Vector<Integer> v1) { // iterator
        Iterator<Integer> iterator = v1.iterator();
        while (iterator.hasNext()) {
            Integer i = iterator.next();
            //如果值是3，做remove操作
            if (i.equals(3)) {
                v1.remove(i);
            }
        }
    }

    // success 不抛异常
    private static void test3(Vector<Integer> v1) { // for
        for (int i = 0; i < v1.size(); i++) {
            //如果值是3，做remove操作
            if (v1.get(i).equals(3)) {
                v1.remove(i);
            }
        }
    }

    public static void main(String[] args) {

        Vector<Integer> vector = new Vector<>();
        vector.add(1);
        vector.add(2);
        vector.add(3);

        //test1(vector); // 抛出异常
        //test2(vector); // 抛出异常
        test3(vector);   // success
    }
}
