package design.pattern.structural.decorator.v2;

/**
 * 抽象装饰者（装饰物）
 *
 * 该角色具有与Component组件相同的接口。
 * Decorator角色知道自已要装饰的对象，持有被装饰物Display。
 */
public abstract class AbstractDecorator extends ABattercake {

    // 表示被装饰物
    private ABattercake aBattercake;

    public AbstractDecorator(ABattercake aBattercake) {
        // 保存传 aBattercake 中
        this.aBattercake = aBattercake;
    }

    // 抽象方法
    protected abstract void doSomething();

    @Override
    protected String getDesc() {
        return this.aBattercake.getDesc();
    }

    @Override
    protected int cost() {
        return this.aBattercake.cost();
    }
}

//public abstract class AbstractDecorator extends ABattercake {
//
//    // 表示被装饰物
//    private ABattercake aBattercake;
//
//    public AbstractDecorator(ABattercake aBattercake) {
//        // 保存传 aBattercake 中
//        this.aBattercake = aBattercake;
//    }
//
//    // 抽象方法
//    protected abstract void doSomething();
//
//}