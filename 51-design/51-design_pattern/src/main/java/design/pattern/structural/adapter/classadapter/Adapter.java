package design.pattern.structural.adapter.classadapter;

/**
 * 适配者
 * 通过适配被适配者来达到目标
 */
public class Adapter extends Adaptee implements Target{
    // 实现目标方法
    @Override
    public void request() {
        //...
        super.adapteeRequest(); // 调用父类Adaptee的方法来实现目标接口里的方法
        //...
    }
}