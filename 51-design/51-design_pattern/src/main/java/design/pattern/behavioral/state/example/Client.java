package design.pattern.behavioral.state.example;

/**
 * 状态模式-状态决定行为
 * https://javap.blog.csdn.net/article/details/112490536
 * 使用场景：在线购物现在已经非常普遍了，拿起手机选择商品，输入付款密码，买家就可以坐等收货了，非常方便。
 * 用户的每条购物记录，都对应着一条订单，订单有非常多的状态，不同的状态可以进行不同的操作。
 */
public class Client {
	public static void main(String[] args) {
		Order order = new Order();
		order.pay();
		order.send();
		order.receive();
		order.cancel();
	}
}
/* Output:
 订单支付.
 卖家发货.
 买家确认收货.
 Exception in thread "main" java.lang.UnsupportedOperationException: 当前状态不支持此操作.
 at design.pattern.behavioral.state.example.state.State.cancel(State.java:36)
 at design.pattern.behavioral.state.example.Order.cancel(Order.java:30)
 at design.pattern.behavioral.state.example.Client.main(Client.java:15)
 */