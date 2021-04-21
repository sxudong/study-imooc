package design.pattern.behavioral.chainofresponsibility.example2;

import lombok.Getter;

/**
 * Request封装客户端的请求
 */
@Getter
public class Request {
	private final int action;
	private final long id;//业务ID

	public Request(int action, long id) {
		this.action = action;
		this.id = id;
	}
}
