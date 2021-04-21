package design.pattern.behavioral.strategy;

/**
 * 19-2 策略模式coding
 *
 * Strategy模式特意将算法与其他部分分离开来，只是定义了与算法相关的接口(API)，然后在程序中以委托的方式来使用算法。
 * 如果使用了“Strategy模式”，就不必修改Strategy角色的接口(API)了，仅仅修改具体策略ConcreteStrategy角色即可。
 * 使用委托这种弱关联关系可以很方便地整体替换算法。
 * 策略模式代表了解决一类算法的通用解决方案。
 */
public class Test {
    /** 策略模式一般都是不会单独的去使用的，一般会结合“单例”结合“工厂方法模式”或者是结合“享元模式”一起来实现一段优雅的业务逻辑。 */
    public static void main(String[] args) {

        // 第一版
//        PromotionActivity promotionActivity618 = new PromotionActivity(new LiJianPromotionStrategy());
//        PromotionActivity promotionActivity1111 = new PromotionActivity(new FanXianPromotionStrategy());
//
//        promotionActivity618.executePromotionStrategy();
//        promotionActivity1111.executePromotionStrategy();

        // 第二版本，根据判断创建具体策略省略......
//        PromotionActivity promotionActivity = null;
//        String promotionKey = "LIJIAN";
//        if(StringUtils.equals(promotionKey, "LIJIAN")) {
//            promotionActivity =  new PromotionActivity(new LiJianPromotionStrategy());
//        } else if (StringUtils.equals(promotionKey, "FANXIAN") ) {
//            promotionActivity =  new PromotionActivity(new FanXianPromotionStrategy());
//        }
//        promotionActivity.executePromotionStrategy();

        // 第三版本，“单例的策略工厂”和“策略模式”组合，根据传入参数获取具体策略（不需要每次new策略，避免多次创建对象）
        String promotionKey = "LIJIAN"; // 立减策略
        PromotionActivity promotionActivity = new PromotionActivity(PromotionStrategyFactory.getPromotionStrategy(promotionKey));
        promotionActivity.executePromotionStrategy();
    }

}
/* Output:
立减促销,课程的价格直接减去配置的价格
*///~