
package com.learn.controller;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

/**
 * 处理器类
 *	负责处理业务逻辑。
 */
public class HelloController implements Controller{

	/*
	 * ModelAndView有两个构造器:
	 * 第一个, ModelAndView(String viewName),viewName是视图名。
	 * 第二个，ModelAndView(String viewName,Map data),data是处理结果。
	 *
	 * http://localhost:8080/spring_day01/hello.do
	 */
	public ModelAndView handleRequest(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		System.out.println("handleRequest()");
		return new ModelAndView("hello");
	}
}
