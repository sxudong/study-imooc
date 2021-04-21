package design.pattern.creational.singleton.imooic6;

import java.io.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

/**
 * 8-7 单例设计模式 -- 反射攻击解决方案及原理分析
 */
public class Test {
    public static void main(String[] args) throws IOException, ClassNotFoundException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {

//        Class objectClass = HungrySingleton.class;
//        Constructor constructor = objectClass.getDeclaredConstructor();
//        constructor.setAccessible(true);
//        HungrySingleton instance = HungrySingleton.getInstance();
//        // 构造器newInstance
//        HungrySingleton newInstance = (HungrySingleton) constructor.newInstance();
//        System.out.println(instance);
//        System.out.println(newInstance);
//        System.out.println(instance==newInstance);

        // 测试静态内部类延迟加载反射
//        Class objectClass = StaticInnerClassSingleton.class;
//        Constructor constructor = objectClass.getDeclaredConstructor();
//        constructor.setAccessible(true);
//        StaticInnerClassSingleton instance = StaticInnerClassSingleton.getInstance();
//        // 构造器newInstance
//        StaticInnerClassSingleton newInstance = (StaticInnerClassSingleton) constructor.newInstance();
//        System.out.println(instance);
//        System.out.println(newInstance);
//        System.out.println(instance == newInstance);

        // 测试静态内部类延迟加载反射
        Class objectClass = LazySingleton.class;
        Constructor constructor = objectClass.getDeclaredConstructor();
        constructor.setAccessible(true);
        LazySingleton instance = LazySingleton.getInstance();
        LazySingleton newInstance = (LazySingleton) constructor.newInstance();
        System.out.println(instance);
        System.out.println(newInstance);
        System.out.println(instance == newInstance);
    }
}
/* Output:
##### 单例模式没有私有构造器 #####
design.pattern.creational.singleton.imooic6.HungrySingleton@2dda6444
design.pattern.creational.singleton.imooic6.HungrySingleton@5e9f23b4
false

##### 单例模式私有构造器 #####
Exception in thread "main" java.lang.reflect.InvocationTargetException
	at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
	at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
	at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
	at java.lang.reflect.Constructor.newInstance(Constructor.java:423)
	at design.pattern.creational.singleton.imooic6.Test.main(Test.java:17)
Caused by: java.lang.RuntimeException: 单例构造器禁止反射调用
	at design.pattern.creational.singleton.imooic6.HungrySingleton.<init>(HungrySingleton.java:20)
	... 5 more
 */