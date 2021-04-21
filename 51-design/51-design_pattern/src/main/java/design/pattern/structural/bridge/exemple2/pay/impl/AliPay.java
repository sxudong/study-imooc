package design.pattern.structural.bridge.exemple2.pay.impl;

import design.pattern.structural.bridge.exemple2.pay.Pay;
import design.pattern.structural.bridge.exemple2.paymode.PayMode;

/**
 * 支付宝平台
 */
public class AliPay extends Pay {

	public AliPay(PayMode payMode) {
		super(payMode);
	}

	@Override
	protected String platform() {
		return "支付宝";
	}
}
