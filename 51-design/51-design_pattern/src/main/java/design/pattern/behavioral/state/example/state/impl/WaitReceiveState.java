package design.pattern.behavioral.state.example.state.impl;

import design.pattern.behavioral.state.example.state.State;

public class WaitReceiveState extends State {
	@Override
	public void receive() {
		System.out.println("买家确认收货.");
		changeState(new FinishedState());
	}
}
