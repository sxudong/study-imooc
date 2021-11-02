package com.myimooc.spring.simple.exposeProxy;

import org.springframework.aop.framework.AopContext;
import org.springframework.stereotype.Component;

/**
 * 在业务类中我们有两个方法 showMessage() 和 formartMsg()。
 * 我们再 showMessage() 中调用 formartMsg() 方法。
 */
@Component
public class MessageService {
	public String showMessage(String info) {
		System.out.println("OtherInfoServcie-showMessage展示信息:"+info);
		//this.formartMsg(info);
		//使用AopContext的静态方法获取当前的代理对象
		((MessageService) AopContext.currentProxy()).formartMsg(info);
		return null;
	}

	public String formartMsg(String info){
		System.out.println("OtherInfoServcie-formartMsg对象消息"+info+"进行格式化");
		return  info;
	}
}
