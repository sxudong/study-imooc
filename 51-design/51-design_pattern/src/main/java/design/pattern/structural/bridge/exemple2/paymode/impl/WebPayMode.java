package design.pattern.structural.bridge.exemple2.paymode.impl;

import design.pattern.structural.bridge.exemple2.paymode.PayMode;

public class WebPayMode implements PayMode {

	@Override
	public String mode() {
		return "Web网站支付";
	}
}