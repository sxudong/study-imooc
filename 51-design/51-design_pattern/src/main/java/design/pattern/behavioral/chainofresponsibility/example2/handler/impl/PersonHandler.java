package design.pattern.behavioral.chainofresponsibility.example2.handler.impl;

import design.pattern.behavioral.chainofresponsibility.example2.Request;
import design.pattern.behavioral.chainofresponsibility.example2.handler.Handler;

// 人员信息处理器
public class PersonHandler extends Handler {

	public PersonHandler() {
		super(PERSON);
	}

	@Override
	protected void handle(Request request) {
		System.out.println("响应id=" + request.getId() + "的人员信息...");
	}
}