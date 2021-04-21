package design.principle.compositionaggregation.v1;

/**
 * 3-11 合成复用原则讲解
 *
 * 继承复用缺点：
 * 1、继承复用破坏了类的封装性。因为继承会将父类的实现细节暴露给子类，父类对子类是透明的，所以这种复用又称为“白箱”复用。
 * 2、子类与父类的耦合度高。父类的实现的任何改变都会导致子类的实现发生变化，这不利于类的扩展与维护。
 * 3、它限制了复用的灵活性。从父类继承而来的实现是静态的，在编译时已经定义，所以在运行时不可能发生变化。
 */
public class Test {

    public static void main(String[]args){
        ProductDao productDao = new ProductDao();
        productDao.addProduct();
    }
} /* Output:
使用MySQL数据库连接增加产品
*///~
