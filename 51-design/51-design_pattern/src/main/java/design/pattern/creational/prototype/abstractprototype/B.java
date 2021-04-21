package design.pattern.creational.prototype.abstractprototype;

/**
 * 9-2 原型模式codeing
 */
public class B extends A {
    public static void main(String[] args) throws CloneNotSupportedException {
        B b = new B();
        B clone = (B) b.clone();
        System.out.println(b == clone);
    }
}
