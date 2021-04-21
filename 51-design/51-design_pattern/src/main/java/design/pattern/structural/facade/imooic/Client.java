package design.pattern.structural.facade.imooic;

/**
 * 10-2 外观模式
 *
 * GiftExchangeService包含资格子系统、物流子系统、积分支付子系统，
 * 它们之间是组合关系，对外部我们只和外观类通讯。所有的子系统业务层
 * 是不用关心的。
 *
 * 优点：
 *     接口（API）变少了。接口变少意味着程序与外部的关联关系变少了，这样更容易我们
 *     的包（类的集合）作为组件被复用.
 *
 * 当某个程序员得意的说出“啊，在调用那个类之前需要先调用这个类。在调用那个方法之前
 * 需要先在这个类中注册一下”的时候，就意味着我们需要引入“Facade角色”了。
 *
 * 注意：在设计类时，需要考虑将哪些方法的可见性设为Public。如果公开的方法过多，会导致
 * 类的内部的修改变得困难。字段也是一样的，如果不小心将某个字段公开出去了，那么其他类
 * 可能会读取或是修改这个字段，导致难以修改该类。
 * 在设计包时，也需要考虑类的可见性。如果包的外部看到了类，包内代码的修改就会变得困难。
 */
public class Client {
    public static void main(String[] args) {
        PointsGift pointsGift = new PointsGift("T恤");
        // 没有Spring注入，硬编码new
        GiftExchangeService giftExchangeService = new GiftExchangeService();
        giftExchangeService.giftExchange(pointsGift);  // 对外部只提供了giftExchange接口，这就是一个简单的窗口
    }
}
/* Output:
校验T恤 积分资格通过,库存通过
支付T恤 积分成功
T恤进入物流系统
物流系统下单成功,订单号是:666
 */