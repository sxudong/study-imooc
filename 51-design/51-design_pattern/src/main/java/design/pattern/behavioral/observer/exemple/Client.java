package design.pattern.behavioral.observer.exemple;

import design.pattern.behavioral.observer.exemple.observable.impl.Pay;
import design.pattern.behavioral.observer.exemple.observer.impl.Express;
import design.pattern.behavioral.observer.exemple.observer.impl.Order;
import design.pattern.behavioral.observer.exemple.observer.impl.Sms;

/**
 * 观察者模式-买家支付完成后的N个通知
 * https://javap.blog.csdn.net/article/details/112392245
 * 场景：假设现在有一个超级简单的商城项目，用户支付成功后，系统需要触发三个动作：
 *   1.修改订单状态。
 *   2.发送扣款短信到用户。
 *   3.通知物流系统开始备货。
 */
public class Client {
	public static void main(String[] args) {
		Pay pay = new Pay();
		pay.add(new Order());
		pay.add(new Sms());
		pay.add(new Express());
		pay.pay();
	}
}
/*
支付完成.
修改订单状态...
账户扣款短信通知...
物流开始备货...
 */