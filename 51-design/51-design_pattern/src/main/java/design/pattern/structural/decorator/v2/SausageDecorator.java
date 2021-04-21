package design.pattern.structural.decorator.v2;

/**
 * 香肠实体装饰者类（具体的装饰物）
 */
public class SausageDecorator extends AbstractDecorator {

    public SausageDecorator(ABattercake aBattercake) {
        // 对象上传到父类
        super(aBattercake);
    }

    @Override
    protected void doSomething() {

    }

    @Override
    protected String getDesc() {
        return super.getDesc() + " 加一根香肠";
    }

    @Override
    protected int cost() {
        return super.cost() + 2;
    }
}

//public class SausageDecorator extends AbstractDecorator {
//
//    // 表示被装饰物
//    private ABattercake aBattercake;
//
//    public SausageDecorator(ABattercake aBattercake) {
//        // 对象上传到父类
//        super(aBattercake);
//        this.aBattercake = aBattercake;
//    }
//
//    @Override
//    protected void doSomething() {
//
//    }
//
//    @Override
//    protected String getDesc() {
//        return aBattercake.getDesc() + " 加一根香肠";
//    }
//
//    @Override
//    protected int cost() {
//        return aBattercake.cost() + 2;
//    }
//}