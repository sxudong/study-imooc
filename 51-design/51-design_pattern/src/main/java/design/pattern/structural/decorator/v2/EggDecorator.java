package design.pattern.structural.decorator.v2;

/**
 * 鸡蛋实体装饰者类（具体的装饰物）
 */
public class EggDecorator extends AbstractDecorator {

    public EggDecorator(ABattercake aBattercake) {
        // 对象上传到父类
        super(aBattercake);
    }

    @Override
    protected void doSomething() {

    }

    @Override
    protected String getDesc() {
        // 调用父类方法获取描述 + 自已的描述 输出
        return super.getDesc() + " 加一个鸡蛋";
    }

    @Override
    protected int cost() {
        // 调用父类方法获取金额 + 自已的金额 输出
        return super.cost() + 1;
    }
}

//public class EggDecorator extends AbstractDecorator {
//
//    // 表示被装饰物
//    private ABattercake aBattercake;
//
//    public EggDecorator(ABattercake aBattercake) {
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
//        // 调用父类方法获取描述 + 自已的描述 输出
//        return aBattercake.getDesc() + " 加一个鸡蛋";
//    }
//
//    @Override
//    protected int cost() {
//        // 调用父类方法获取金额 + 自已的金额 输出
//        return aBattercake.cost() + 1;
//    }
//}
