package design.pattern.creational.singleton.imooic6;

import design.annoations.NotThreadSafe;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;

/**
 * 8-7 反射攻击，通过反射修改 flag属性字段
 */
@NotThreadSafe
public class LazySingleton2 {
    private static LazySingleton2 lazySingleton = null;
    private static boolean flag = true;

    private LazySingleton2() {
        // 这种方法没有什么意义，反射也可以反射这个属性
        if(flag) {
            flag = false;
        } else {
            throw new RuntimeException("单例构造器禁止反射调用");
        }
//        if(lazySingleton != null){
//            throw new RuntimeException("单例构造器禁止反射调用");
//        }
    }

    public static LazySingleton2 getInstance(){
        if(lazySingleton == null){
            lazySingleton = new LazySingleton2();
        }
        return lazySingleton;
    }

    public static void main(String[] args) throws NoSuchMethodException,
            IllegalAccessException, InvocationTargetException,
            InstantiationException, NoSuchFieldException {

        // 反射修改构造器权限
        Class objectClass = LazySingleton2.class;
        Constructor c = objectClass.getDeclaredConstructor(); // 获取构造器
        c.setAccessible(true); // 设置它的权限为 true

        // 拿到对象 o1
        LazySingleton2 o1 = LazySingleton2.getInstance();

        // 反射拿到 flag 属性，将其修改为 true
        Field flag = o1.getClass().getDeclaredField("flag");
        flag.setAccessible(true); // 权限打开
        flag.set(o1, true);  // 值修改为 true

        // 反射实例化对象 o2
        LazySingleton2 o2 = (LazySingleton2) c.newInstance();

        System.out.println(o1);
        System.out.println(o2);
        System.out.println(o1==o2); //false 对象不一样，反射攻击成功
    }
}
/* Output:
design.pattern.creational.singleton.imooic6.LazySingleton2@5e9f23b4
design.pattern.creational.singleton.imooic6.LazySingleton2@4783da3f
false
 */