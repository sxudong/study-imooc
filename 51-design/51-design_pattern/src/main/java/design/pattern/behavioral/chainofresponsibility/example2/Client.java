package design.pattern.behavioral.chainofresponsibility.example2;

import design.pattern.behavioral.chainofresponsibility.example2.handler.Handler;

/**
 * 责任链模式-谁来处理请求？
 * https://javap.blog.csdn.net/article/details/112253655
 *
 * 需求:
 * 系统需要对外开放一些接口，以供第三方平台调用。大致流程是第三方发送一个HTTP请求，携带签名和一些业务参数，我这边接收到请求后根据参数做出响应。
 * 其中比较重要的一个参数是【action】，它代表客户端要请求的动作，分别是:
 *   1.请求项目信息
 *   2.请求合同信息
 *   3.请求人员信息
 */
public class Client {
//	public static void main(String[] args) {
//		action(new Request(1,99));
//		action(new Request(2,99));
//		action(new Request(3,99));
//		action(new Request(4,99));
//	}
//
//	static void action(Request request) {
//		if (request.getAction() == 1) {
//			new ProjectHandler().handleRequest(request);
//		} else if (request.getAction() == 2) {
//			new ContractHandler().handleRequest(request);
//		} else if (request.getAction() == 3) {
//			new PersonHandler().handleRequest(request);
//		}else {
//			System.out.println("无效请求...");
//		}
//	}
	public static void main(String[] args) {
		Handler chain = ChainBuilder.build();
		chain.handleRequest(new Request(1, 99));
		chain.handleRequest(new Request(2, 99));
		chain.handleRequest(new Request(3, 99));
		chain.handleRequest(new Request(4, 99));
	}
}
/* Output:
响应id=99的项目信息...
响应id=99的合同信息...
响应id=99的人员信息...
无效请求...
 */
