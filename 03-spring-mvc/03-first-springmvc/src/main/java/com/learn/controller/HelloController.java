
package com.learn.controller;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

/**
 * 处理器类
 *	负责处理业务逻辑。
 *  一旦 Web 应用启动的时候，我们就能在任意的 Servlet 或者 JSP 中通过下面的方式
 *  获取我们在 com.learn.listener.MyDataContextListener 中初始化的参数，如下：
 *     String myData = (String) req.getServletContext().getAttribute("myData");
 *
 *  http://localhost:8080/springmvc/hello.do
 *
 * 达内 spring_day01
 */
public class HelloController implements Controller{

	/*
	 * ModelAndView有两个构造器:
	 * 第一个, ModelAndView(String viewName),viewName是视图名。
	 * 第二个，ModelAndView(String viewName,Map data),data是处理结果。
	 *
	 * http://localhost:8080/springmvc/hello.do
	 */
	public ModelAndView handleRequest(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		// 获取自定义监听器中设置的值
		String myData = (String) req.getServletContext().getAttribute("myData");
		System.out.println(myData);
		// int i = 10/0; // 测试异常处理解析器MyExceptionHandler
		System.out.println("handleRequest()");
		return new ModelAndView("hello");
	}
}
