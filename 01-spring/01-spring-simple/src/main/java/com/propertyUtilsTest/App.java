package com.propertyUtilsTest;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;

/**
 * 常用的工具类之 Apache Commons BeanUtils 简单使用与部分原理解析
 * https://blog.csdn.net/m0_37225642/article/details/106445040
 *
 * BeanUtils：主要提供了对于 JavaBean 进行各种操作，比如对象，属性复制等等，自动转换数据类型。
 * PropertyUtils：用处大致与 BeanUtils 相同，但是如果类型不能自动转换会抛异常。
 * CollectionUtils：集合处理类，集合类型转化，取交集、并集等方法。
 * ConvertUtils：数据类型转换类，BeanUtils 的自动类型转换就要到了它。
 */
public class App {
    public static void main( String[] args ) throws InvocationTargetException, IllegalAccessException {
//        Dog dog = new Dog();
//        Map<String, Object> map = new HashMap<>();
//        map.put("age",2);
//        map.put("name","huahua");
//
//        try {
//            BeanUtils.populate(dog,map);
//        } catch (IllegalAccessException e) {
//            e.printStackTrace();
//        } catch (InvocationTargetException e) {
//            e.printStackTrace();
//        } finally {
//        }
//
//        System.out.println("dog:" + dog); //dog:Dog{name='huahua', age=2}


        // copyProperties 方法
        Animal animal = new Animal();
        animal.setName("mimi");
        animal.setType("dog");
        animal.setAge(2);

        Dog dog = new Dog();
        BeanUtils.copyProperties(dog,animal);
        System.out.println("将 animal 值赋给 dog：");
        System.out.println(dog); // Dog{name='mimi', age=2}

        //如果被copy对象缺少目标对象中的某些属性，那么目标对象中的对应值为 null
        Animal animal1 = new Animal();
        BeanUtils.copyProperties(animal1,dog);
        System.out.println("将 dog 值赋给 animal1 对象：");
        System.out.println(animal1); // Animal{name='mimi', type='null', age=2}

        // copyProperty 方法
        animal.setName("huahua");
        BeanUtils.copyProperty(dog,"name",animal.getName());
        System.out.println("改变 animal name属性，并赋给 dog：");
        System.out.println(dog); // Dog{name='huahua', age=2}

        // setProperty 方法
        BeanUtils.setProperty(dog,"age",3);
        System.out.println("给 dog 的 age 属性赋值：");
        System.out.println(dog); // Dog{name='huahua', age=3}

        // cloneBean 方法
        try {
            Animal animal2 = (Animal)BeanUtils.cloneBean(animal1);
            System.out.println("通过 animal1 克隆 animal2 对象：");
            System.out.println(animal2); // Animal{name='mimi', type='null', age=2}
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
}