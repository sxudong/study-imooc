package design.pattern.creational.singleton.imooic7;

import java.io.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

/**
 * 8-8 单例设计模式-Enum枚举单例、原理源码解析以及反编译实战
 */
public class Test {
    public static void main(String[] args) throws IOException, ClassNotFoundException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {

//        EnumInstance instance = EnumInstance.getInstance();
//        instance.setData(new Object());
//
//        ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("singleton_file"));
//        oos.writeObject(instance);
//
//        File file = new File("singleton_file");
//        ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file));
//        EnumInstance newInstance = (EnumInstance) ois.readObject();
//
//        System.out.println(instance.getData());
//        System.out.println(newInstance.getData());
//        System.out.println(instance.getData() == newInstance.getData());

        //测试枚举反射
//        Class objectClass = EnumInstance.class;
//        Constructor constructor = objectClass.getDeclaredConstructor(String.class); // 报错 NoSuchMethodException 没有找到无参构造器，EnumInstance只有一个两个参数的构造器
//        constructor.setAccessible(true);
//        EnumInstance instance = (EnumInstance) constructor.newInstance("Geely");
        // 两个参数的构造器
        Class objectClass = EnumInstance.class;
        Constructor constructor = objectClass.getDeclaredConstructor(String.class, int.class); // 报错 IllegalArgumentException: Cannot reflectively create enum objects 无法反射地创建枚举对象
        constructor.setAccessible(true);
        EnumInstance instance = (EnumInstance) constructor.newInstance("Geely", 666);

         //调用枚举中方法
//        EnumInstance instance = EnumInstance.getInstance();
//        instance.printTest();

    }
}
