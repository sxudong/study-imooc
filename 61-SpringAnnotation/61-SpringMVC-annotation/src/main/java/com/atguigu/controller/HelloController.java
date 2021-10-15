package com.atguigu.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.service.HelloService;

@Controller
public class HelloController {
	
	@Autowired
	HelloService helloService;

	/**
	 * 通过SpringMVC配置里ViewResolver的Bean配置，说明我们的页面放置路径是／WEB-INF/views/index.jsp
	 * @return
	 */
	//这里一定要对类进行拦截
	@RequestMapping("/")
	public String index() {
		System.out.println("controller");
		return "index";
	}

	// http://localhost:8080/61_SpringMVC_annotation/hello
	@ResponseBody
	@RequestMapping("/hello")
	public String hello(){
		String hello = helloService.sayHello("tomcat..");
		return hello;
	}
	/* 浏览器输出：
		Hello tomcat..
	 */

	// http://localhost:8080/springmvc_annotation_war/suc
	// /WEB-INF/views/success.jsp
	@RequestMapping("/suc")
	public String success(){
		return "success";
	}/* 浏览器输出：
	  success!
	*///~
}
