package com.atguigu.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 53、servlet3.0-简介&测试
 *
 * http://localhost:8080/servlet3_0_war/hello
 */
@WebServlet("/hello") // 注册 servlet用 @WebServlet 注解, 如果要注册Filter用 @WebFilter，要注册监听用 @WebListener
public class HelloServlet extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//super.doGet(req, resp);
		System.out.println(Thread.currentThread()+" start...");
		try {
			sayHello();
		} catch (Exception e) {
			e.printStackTrace();
		}
		resp.getWriter().write("hello...");
		System.out.println(Thread.currentThread()+" end...");
	}
	
	public void sayHello() throws Exception{
		System.out.println(Thread.currentThread()+" processing...");
		Thread.sleep(3000);
	}

}
/*
Thread[http-nio-8080-exec-5,5,main] start...
Thread[http-nio-8080-exec-5,5,main] processing...
Thread[http-nio-8080-exec-5,5,main] end...
*///~