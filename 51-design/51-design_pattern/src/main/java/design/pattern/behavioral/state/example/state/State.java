package design.pattern.behavioral.state.example.state;

import design.pattern.behavioral.state.example.Order;

/**
 * 假设订单存在如下四种状态：
 *   1.待支付。
 *   2.待发货。
 *   3.待收货。
 *   4.订单完成结束。
 *
 * 针对订单可以有如下四种操作：
 *   1.支付金额。
 *   2.取消订单。
 *   3.卖家发货。
 *   4.买家确认收货。
 */
public abstract class State {
	protected Order order;

	// 修改状态
	protected final void changeState(State state){
		order.setState(state);
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	// 默认所有的操作都不支持，子类重写
	public void pay(){
		throw new UnsupportedOperationException("当前状态不支持此操作.");
	}

	public void cancel(){
		throw new UnsupportedOperationException("当前状态不支持此操作.");
	}

	public void send(){
		throw new UnsupportedOperationException("当前状态不支持此操作.");
	}

	public void receive() {
		throw new UnsupportedOperationException("当前状态不支持此操作.");
	}
}
