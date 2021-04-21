package design.pattern.structural.bridge.exemple2.pay;

import design.pattern.structural.bridge.exemple2.paymode.PayMode;

public abstract class Pay {
	protected PayMode payMode;//支付方式抽象

	public Pay(PayMode payMode) {
		this.payMode = payMode;
	}

	protected abstract String platform();//支付平台

	public final void pay(){
		System.out.println("使用:" + platform() + "的" + payMode.mode());
	}
}
