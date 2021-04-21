package design.pattern.structural.adapter.objectadapter;

/**
 * 适配者
 * 通过适配被适配者来达到目标
 *
 * 适配类和上面的有一些不同，这里被适配类不是继承过来的，而是
 * 作为属性组合到里面来，然后通过对象来调用被适配类里面的方法。
 */
public class Adapter implements Target {
    // 被适配者Adaptee组合到适配器中
    private Adaptee adaptee = new Adaptee();

    // 通过组合的方式把具体实现Target的request方法委托给adaptee来实现
    @Override
    public void request() {
        //...
        adaptee.adapteeRequest();
        //...
    }
}
