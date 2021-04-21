package design.pattern.structural.adapter.objectadapter;

/**
 * 对象适配器模式
 *
 * 一个是通过继承关系，一个是通过组合关系，这是类适配器模式和对象适配器模式之间的区别
 */
public class Test {
    public static void main(String[] args) {
        Target target = new ConcreteTarget();
        target.request();

        Target adapterTarget = new Adapter();
        adapterTarget.request();
    }
}
/* Output:
concreteTarget目标方法
被适配者的方法
*///~