package com.atguigu;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

/**
 * 设定HashMap容量 (阿里巴巴Java开发手册 p28)
 * https://www.cnblogs.com/hollischuang/p/12009172.html
 */
public class TestHashMapCapacity {
    public static void main(String[] args) throws NoSuchMethodException,
            InvocationTargetException, IllegalAccessException, NoSuchFieldException {

        int a = (int) ((100/0.75)+1);
        Map<String, String> map = new HashMap<String, String>();
        //Map<String, String> map = new HashMap<String, String>(a);

        for (int i = 0; i <100 ; i++) {
            map.put(String.valueOf(i), "a");
        }

        Class<?> mapType = map.getClass();
        Method capacity = mapType.getDeclaredMethod("capacity");
        capacity.setAccessible(true);
        System.out.println("capacity : " + capacity.invoke(map));

        Field size = mapType.getDeclaredField("size");
        size.setAccessible(true);
        System.out.println("size : " + size.get(map));
    }
}
/* Output:
capacity : 256
size : 100
*///~