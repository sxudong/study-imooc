package design.pattern.structural.bridge.exemple2.pay.impl;

import design.pattern.structural.bridge.exemple2.pay.Pay;
import design.pattern.structural.bridge.exemple2.paymode.PayMode;

/**
 * 微信支付平台
 */
public class WeChatPay extends Pay {

	public WeChatPay(PayMode payMode) {
		super(payMode);
	}

	@Override
	protected String platform() {
		return "微信";
	}
}