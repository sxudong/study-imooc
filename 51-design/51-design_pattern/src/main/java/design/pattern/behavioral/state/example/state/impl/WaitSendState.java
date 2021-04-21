package design.pattern.behavioral.state.example.state.impl;

import design.pattern.behavioral.state.example.state.State;

public class WaitSendState extends State {

	@Override
	public void send() {
		System.out.println("卖家发货.");
		changeState(new WaitReceiveState());
	}
}
