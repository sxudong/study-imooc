package design.pattern.behavioral.state.example;

/**
 * 订单状态枚举
 */
@Deprecated
public enum StateEnum {
	WAIT_PAY,//待支付
	WAIT_SEND,//待发货
	WAIT_RECEIVE,//等待收货
	FINISHED;//订单结束
}
