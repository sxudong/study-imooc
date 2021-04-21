package design.pattern.behavioral.state.example;


import design.pattern.behavioral.state.example.state.State;
import design.pattern.behavioral.state.example.state.impl.WaitPayState;

/**
 * 核心订单类
 */
public class Order {
	//private StateEnum state;//当前订单状态
	private State state;

	public Order() {
		// 默认 待支付
		state = new WaitPayState();
		state.setOrder(this);
	}

	public void setState(State state) {
		state.setOrder(this);
		this.state = state;
	}

	public void pay(){
		state.pay();
	}

	public void cancel(){
		state.cancel();
	}

	public void send() {
		state.send();
	}

	public void receive() {
		state.receive();
	}
}
