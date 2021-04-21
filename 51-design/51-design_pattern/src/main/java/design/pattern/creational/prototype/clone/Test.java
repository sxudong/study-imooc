package design.pattern.creational.prototype.clone;

import design.pattern.creational.singleton.HungrySingleton;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;

/**
 * 9-2 原型模式codeing
 */
public class Test {
    public static void main(String[] args) throws CloneNotSupportedException, NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        Date birthday = new Date(0L);
        Pig pig1 = new Pig("佩奇", birthday);
        Pig pig2 = (Pig) pig1.clone();
        System.out.println(pig1);
        System.out.println(pig2);

        pig1.getBirthday().setTime(666666666666L);

        System.out.println(pig1);
        System.out.println(pig2);

        // 9-3 原型模式coding-克隆破坏单例
        HungrySingleton hungrySingleton = HungrySingleton.getInstance();
        Method method = hungrySingleton.getClass().getDeclaredMethod("clone");
        method.setAccessible(true);
        HungrySingleton cloneHungrySingleton = (HungrySingleton) method.invoke(hungrySingleton);
        System.out.println(hungrySingleton);
        System.out.println(cloneHungrySingleton);
    }
}
/* Output:
Pig{name='佩奇', birthday=Thu Jan 01 08:00:00 CST 1970}design.pattern.creational.prototype.clone.Pig@52cc8049
Pig{name='佩奇', birthday=Thu Jan 01 08:00:00 CST 1970}design.pattern.creational.prototype.clone.Pig@5b6f7412
Pig{name='佩奇', birthday=Sat Feb 16 09:11:06 CST 1991}design.pattern.creational.prototype.clone.Pig@52cc8049
Pig{name='佩奇', birthday=Thu Jan 01 08:00:00 CST 1970}design.pattern.creational.prototype.clone.Pig@5b6f7412
design.pattern.creational.singleton.HungrySingleton@312b1dae
design.pattern.creational.singleton.HungrySingleton@312b1dae
 *///~