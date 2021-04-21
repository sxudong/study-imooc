package design.pattern.structural.decorator.v1;

/**
 * 示例：都是靠继承，没有的就得新加
 *
 */
public class Test {
    public static void main(String[] args) {
        Battercake battercake = new Battercake();
        System.out.println(battercake.getDesc()+" 销售价格:"+battercake.cost());

        Battercake battercakeWithEgg = new BattercakeWithEgg();
        System.out.println(battercakeWithEgg.getDesc()+" 销售价格:"+battercakeWithEgg.cost());

        Battercake battercakeWithEggSausage = new BattercakeWithEggSausage();
        System.out.println(battercakeWithEggSausage.getDesc()+" 销售价格:"+battercakeWithEggSausage.cost());

        // 有个小伙伴要加2个鸡蛋的，没有。

    }
}
/* Output:
煎饼 销售价格:8
煎饼 加一个鸡蛋 销售价格:9
煎饼 加一个鸡蛋 加一根香肠 销售价格:11
*///~