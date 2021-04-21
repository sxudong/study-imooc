package design.pattern.behavioral.chainofresponsibility.example2.handler;

import design.pattern.behavioral.chainofresponsibility.example2.Request;

/**
 * 抽象Handler类，采用模板方法模式，将所有处理器串成一条链。
 */
public abstract class Handler {
	public static final int PROJECT = 1;//项目信息
	public static final int CONTRACT = 2;//合同信息
	public static final int PERSON = 3;//人员信息
	protected final int action;//当前处理者能处理的action
	private Handler next;// 下一个处理者

	public Handler(int action) {
		this.action = action;
	}

	public final void handleRequest(Request request) {
		if (request.getAction() == this.action) {
			// 是当前Handler要处理的
			handle(request);
		} else if (next != null) {
			// 交给下一个Handler处理
			next.handleRequest(request);
		} else {
			// 没有Handler可以处理
			System.out.println("无效请求...");
		}
	}

	public void setNext(Handler next) {
		this.next = next;
	}

	// 处理请求，子类实现
	protected abstract void handle(Request request);
}
