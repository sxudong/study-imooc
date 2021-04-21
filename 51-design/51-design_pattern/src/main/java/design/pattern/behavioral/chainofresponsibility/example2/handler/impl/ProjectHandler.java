package design.pattern.behavioral.chainofresponsibility.example2.handler.impl;

import design.pattern.behavioral.chainofresponsibility.example2.Request;
import design.pattern.behavioral.chainofresponsibility.example2.handler.Handler;

// 项目信息处理器
public class ProjectHandler extends Handler {

	public ProjectHandler() {
		super(PROJECT);
	}

	@Override
	protected void handle(Request request) {
		System.out.println("响应id=" + request.getId() + "的项目信息...");
	}
}