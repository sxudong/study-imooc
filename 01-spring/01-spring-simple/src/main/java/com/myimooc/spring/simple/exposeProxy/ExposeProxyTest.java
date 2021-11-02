package com.myimooc.spring.simple.exposeProxy;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

/**
 * spring应用手册-AOP(注解)-(27)-EnableAspectJAutoProxy 的 exposeProxy 属性
 * https://blog.csdn.net/q2780004063/article/details/109146628
 */
public class ExposeProxyTest {
	public static void main(String[] args) {
		ApplicationContext ac =
				new AnnotationConfigApplicationContext(AppConfig.class);
		MessageService bean = ac.getBean(MessageService.class);
		bean.showMessage("戴着假发的程序员");
	}
}
/* @EnableAspectJAutoProxy，结果：shwoMessage()方法被拦截了，但是 formartMsg() 方法并没有被拦截。
前置通知,被增强的方法是:execution(String com.gqzdev.aop.exposeProxy.MessageService.showMessage(String))
OtherInfoServcie-showMessage展示信息:戴着假发的程序员
OtherInfoServcie-formartMsg对象消息戴着假发的程序员进行格式化
*///~

/* @EnableAspectJAutoProxy(exposeProxy=true)，((MessageService) AopContext.currentProxy()).formartMsg(info)，现在 formartMsg()方法被拦截了。
前置通知,被增强的方法是:execution(String com.gqzdev.aop.exposeProxy.MessageService.showMessage(String))
OtherInfoServcie-showMessage展示信息:戴着假发的程序员
前置通知,被增强的方法是:execution(String com.gqzdev.aop.exposeProxy.MessageService.formartMsg(String))
OtherInfoServcie-formartMsg对象消息戴着假发的程序员进行格式化
*///~