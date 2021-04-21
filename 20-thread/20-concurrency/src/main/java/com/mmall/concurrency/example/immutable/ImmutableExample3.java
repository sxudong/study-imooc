package com.mmall.concurrency.example.immutable;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.mmall.concurrency.annoations.ThreadSafe;

/**
 * 6-2 不可变对象：ImmutableList.of()
 *
 * com.google.common.collect.ImmutableList
 * com.google.common.collect.ImmutableMap
 * com.google.common.collect.ImmutableSet
 */
@ThreadSafe
public class ImmutableExample3 {

    private final static ImmutableList<Integer> list = ImmutableList.of(1, 2, 3);

    private final static ImmutableSet set = ImmutableSet.copyOf(list);

    private final static ImmutableMap<Integer, Integer> map =
            ImmutableMap.of(1, 2, 3, 4);

    private final static ImmutableMap<Integer, Integer> map2 =
            ImmutableMap.<Integer, Integer>builder().put(1, 2).put(3, 4).put(5, 6).build();


    public static void main(String[] args) {
        //list.add(4); //不可修改，抛出异常
        //set.add(4);  //不可修改，抛出异常
        System.out.println(map2.get(3));  //输出：4
    }
}
