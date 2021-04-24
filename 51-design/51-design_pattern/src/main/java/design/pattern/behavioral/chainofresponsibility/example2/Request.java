package design.pattern.behavioral.chainofresponsibility.example2;


/**
 * Request封装客户端的请求
 */
public class Request {
	private final int action;
	private final long id;//业务ID

	public Request(int action, long id) {
		this.action = action;
		this.id = id;
	}

	public int getAction() {
		return action;
	}

	public long getId() {
		return id;
	}
}
