package com.atguigu.servlet;

import java.io.IOException;

import javax.servlet.AsyncContext;
import javax.servlet.ServletException;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 59、servlet3.0-异步请求
 * http://localhost:8080/servlet3_0_war/async
 */
@WebServlet(value = "/async", asyncSupported = true) // 通过 @WebServlet 注解注册 servlet
public class HelloAsyncServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //1、支持异步处理asyncSupported=true
        //2、开启异步模式
        System.out.println("主线程开始。。。" + Thread.currentThread() + "==>" + System.currentTimeMillis());
        AsyncContext startAsync = req.startAsync();

        //3、业务逻辑进行异步处理;开始异步处理
        startAsync.start(new Runnable() {
            @Override
            public void run() {
                try {
                    System.out.println("副线程开始。。。" + Thread.currentThread() + "==>" + System.currentTimeMillis());
                    sayHello();
                    startAsync.complete();
                    //获取到异步上下文
                    AsyncContext asyncContext = req.getAsyncContext();
                    //4、获取响应
                    ServletResponse response = asyncContext.getResponse();
                    response.getWriter().write("hello async...");
                    System.out.println("副线程结束。。。" + Thread.currentThread() + "==>" + System.currentTimeMillis());
                } catch (Exception e) {
                }
            }
        });
        System.out.println("主线程结束。。。" + Thread.currentThread() + "==>" + System.currentTimeMillis());
    }

    public void sayHello() throws Exception {
        System.out.println(Thread.currentThread() + " processing...");
        Thread.sleep(3000);
    }
}
/* Output: 堵塞在Tthread.sleep()
主线程开始。。。Thread[http-nio-8080-exec-4,5,main]==>1596013018066
主线程结束。。。Thread[http-nio-8080-exec-4,5,main]==>1596013018072
副线程开始。。。Thread[http-nio-8080-exec-5,5,main]==>1596013018072
Thread[http-nio-8080-exec-5,5,main] processing...
 *///~