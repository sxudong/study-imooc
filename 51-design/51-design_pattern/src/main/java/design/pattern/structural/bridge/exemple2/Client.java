package design.pattern.structural.bridge.exemple2;

import design.pattern.structural.bridge.exemple2.pay.impl.AliPay;
import design.pattern.structural.bridge.exemple2.pay.Pay;
import design.pattern.structural.bridge.exemple2.paymode.impl.FacePayMode;
import design.pattern.structural.bridge.exemple2.paymode.impl.MobilePayMode;

/**
 * 桥接模式-支付功能的扩展
 * https://javap.blog.csdn.net/article/details/112633453
 */
public class Client {
	public static void main(String[] args) {
		Pay pay = new AliPay(new FacePayMode());
		pay.pay();
		pay = new AliPay(new MobilePayMode());
		pay.pay();
	}
}
/* Output:
使用:支付宝的刷脸支付
使用:支付宝的移动端支付
 */
