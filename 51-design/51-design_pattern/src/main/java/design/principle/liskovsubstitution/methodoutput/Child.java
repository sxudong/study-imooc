package design.principle.liskovsubstitution.methodoutput;

import java.util.HashMap;

/**
 * 当子类的方法实现父类的抽象方法时（重写/重载或实现抽象方法），
 * 方法的后置条件（即方法的输出/返回值）要比父类更严格或相等。
 */
public class Child extends Base {

    @Override
    public HashMap method() {
        HashMap hashMap = new HashMap();
        System.out.println("子类method被执行");
        hashMap.put("message","子类method被执行");
        return hashMap;
    }
}
