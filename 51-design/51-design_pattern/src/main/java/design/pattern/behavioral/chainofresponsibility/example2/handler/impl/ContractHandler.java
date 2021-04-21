package design.pattern.behavioral.chainofresponsibility.example2.handler.impl;

import design.pattern.behavioral.chainofresponsibility.example2.Request;
import design.pattern.behavioral.chainofresponsibility.example2.handler.Handler;

// 合同信息处理器
public class ContractHandler extends Handler {

	public ContractHandler() {
		super(Handler.CONTRACT);
	}

	@Override
	protected void handle(Request request) {
		System.out.println("响应id=" + request.getId() + "的合同信息...");
	}
}