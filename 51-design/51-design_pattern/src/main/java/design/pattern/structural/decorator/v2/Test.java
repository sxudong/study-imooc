package design.pattern.structural.decorator.v2;

/**
 * 11-2 装饰者模式
 */
public class Test {
    public static void main(String[] args) {
//        ABattercake aBattercake; // 声明一个抽象煎饼
//        aBattercake = new Battercake(); // 实体煎饼
//        // 在煎饼基础上加装饰
//        aBattercake = new EggDecorator(aBattercake);     // 鸡蛋实体装饰者类，装饰之后再赋值给 aBattercake
//        aBattercake = new EggDecorator(aBattercake);     // 再加一个鸡蛋，装饰之后再赋值给 aBattercake
//        aBattercake = new SausageDecorator(aBattercake); // 香肠实体装饰者类，装饰之后再赋值给 aBattercake
//        System.out.println(aBattercake.getDesc() + " 销售价格:" + aBattercake.cost());

        // 下面这个实例比上面的更易于理解
        ABattercake b1 = new Battercake();
        ABattercake b2 = new EggDecorator(b1);      // 加1个鸡蛋
        ABattercake b3 = new EggDecorator(b2);      // 再加1个鸡蛋
        ABattercake b4 = new SausageDecorator(b3);  // 加1个香肠
        // 它们之间的关系 b4 -> b3 -> b2 -> b1

        System.out.println(b4.getDesc() + " 销售价格:" + b4.cost());
    }
}
/* Output:
煎饼 加一个鸡蛋 加一个鸡蛋 加一根香肠 销售价格:12
 */