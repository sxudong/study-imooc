package design.pattern.creational.prototype.abstractprototype;

/**
 * 通过“抽象类”来实现原型模式
 */
public abstract class A implements Cloneable{
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
