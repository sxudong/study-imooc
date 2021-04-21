package design.principle.liskovsubstitution.methodinput;


import java.util.Map;

/**
 * 当子类的方法重载父类的方法时，方法的前置条件（即方法的输入/入参）
 * 要比父类方法的输入参数更加宽松。
 */
public class Child extends Base {
//    @Override
//    public void method(HashMap map) {
//        System.out.println("子类HashMap入参方法被执行");
//    }

    public void method(Map map) {
        System.out.println("子类HashMap入参方法被执行");
    }
}