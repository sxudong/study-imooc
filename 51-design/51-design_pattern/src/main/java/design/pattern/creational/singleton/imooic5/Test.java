package design.pattern.creational.singleton.imooic5;

import java.io.*;
import java.lang.reflect.InvocationTargetException;

/**
 * 8-6 单例设计模式 -- 序列化破坏单例模式原理解析及解决方案
 * 一旦业务场景涉及序列化，反序列化的时候，一定要注意对单例的破坏。
 */
public class Test {
    public static void main(String[] args) throws IOException, ClassNotFoundException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {

        HungrySingleton instance = HungrySingleton.getInstance();
        ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("singleton_file"));
        oos.writeObject(instance);

        File file = new File("singleton_file");
        ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file));

        // ObjectInputStream#readObject() -> readObject0(false){ switch (tc) case TC_OBJECT: return checkResolve(readOrdinaryObject(unshared));}
        // -> readOrdinaryObject() { obj = desc.isInstantiable() ? desc.newInstance() : null; return obj;}
        //   看desc.isInstantiable()方法的注释说明，desc.isInstantiable()返回true, 就会newInstance(),newInstance()是通过反射创建出来的对象。
        //   -> ObjectStreamClass#hasReadResolveMethod() 判断是否有 readResolve()方法
        //     -> Object rep = desc.invokeReadResolve(obj); 反射调用readResolve()方法
        //     -> return readResolveMethod.invoke(obj, (Object[]) null);
        //    在ObjectStreamClass类构造器中定义了目标方法名 readResolveMethod
        HungrySingleton newInstance = (HungrySingleton) ois.readObject();
        System.out.println(instance);
        System.out.println(newInstance);
        System.out.println(instance == newInstance);
    }
}
/* Output:
design.pattern.creational.singleton.HungrySingleton@6e2c634b
design.pattern.creational.singleton.HungrySingleton@6e2c634b
true
 */