package design.pattern.behavioral.state.example.state.impl;

import design.pattern.behavioral.state.example.state.State;

public class WaitPayState extends State {

	@Override
	public void pay() {
		System.out.println("订单支付.");
		changeState(new WaitSendState());
	}

	@Override
	public void cancel() {
		System.out.println("取消订单.");
		changeState(new FinishedState());
	}
}
