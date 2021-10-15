package com.atguigu.controller;

import java.util.UUID;
import java.util.concurrent.*;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.async.DeferredResult;

import com.atguigu.service.DeferredResultQueue;


@Controller
public class AsyncController {


    /**
     * 61、springmvc-异步请求-返回DeferredResult
     * http://localhost:8080/61_SpringMVC_annotation/createOrder
     */
    @ResponseBody
    @RequestMapping("/createOrder")
    public DeferredResult<Object> createOrder() {
        // 限定5秒内完成
        DeferredResult<Object> deferredResult = new DeferredResult<>((long) 5000, "create fail...");
        // 保存起来
        DeferredResultQueue.save(deferredResult);

        return deferredResult;
    }
    /* 浏览器输出：
        create fail...
     */


    //http://localhost:8080/61_SpringMVC_annotation/create
    @ResponseBody
    @RequestMapping("/create")
    public String create() {
        //创建订单"/createOrder"保存的信息
        String order = UUID.randomUUID().toString();
        // 队更中取出
        DeferredResult<Object> deferredResult = DeferredResultQueue.get();
        deferredResult.setResult(order);
        return "success===>" + order;
    }
    /* 浏览器输出：
        success===>2c2e829a-421b-4d20-8365-ae04d3b1e081
     */

    /**
     * 60、springmvc-异步请求-返回Callable
     * 1、控制器返回Callable
     * 2、Spring异步处理，将Callable 提交到 TaskExecutor 使用一个隔离的线程进行执行
     * 3、DispatcherServlet 和所有的 Filter 退出 web容器 的线程，但是 response 保持打开状态；
     * 4、Callable返回结果，SpringMVC将请求重新派发给容器，恢复之前的处理；
     * 5、根据Callable返回的结果。SpringMVC继续进行视图渲染流程等（从收请求-视图渲染）。
     * <p>
     * preHandle.../springmvc-annotation/async01
     * 主线程开始...Thread[http-bio-8081-exec-3,5,main]==>1513932494700
     * 主线程结束...Thread[http-bio-8081-exec-3,5,main]==>1513932494700
     * =========DispatcherServlet及所有的Filter退出线程============================
     * <p>
     * ================等待Callable执行==========
     * 副线程开始...Thread[MvcAsync1,5,main]==>1513932494707
     * 副线程开始...Thread[MvcAsync1,5,main]==>1513932496708
     * ================Callable执行完成==========
     * <p>
     * ================再次收到之前重发过来的请求========
     * preHandle.../springmvc-annotation/async01
     * postHandle...（Callable的之前的返回值就是目标方法的返回值）
     * afterCompletion...
     * <p>
     * 异步的拦截器:
     * 1）、原生API的AsyncListener
     * 2）、SpringMVC：实现AsyncHandlerInterceptor；
     *
     * http://localhost:8080/61_SpringMVC_annotation/async01
     */
    @ResponseBody
    @RequestMapping("/async01")
    public Callable<String> async01() throws ExecutionException, InterruptedException {
        System.out.println("主线程开始..." + Thread.currentThread() + "==>" + System.currentTimeMillis());

        Callable<String> callable = new Callable<String>() {
            @Override
            public String call() throws Exception {
                System.out.println("副线程开始..." + Thread.currentThread() + "==>" + System.currentTimeMillis());
                Thread.sleep(2000);
                System.out.println("副线程开始..." + Thread.currentThread() + "==>" + System.currentTimeMillis());
                return "Callable<String> async01()";
            }
        };

        System.out.println("主线程结束..." + Thread.currentThread() + "==>" + System.currentTimeMillis());
        return callable;
    } /* Output:
		preHandle.../springmvc_annotation_war/async01
		主线程开始...Thread[http-nio-8080-exec-4,5,main]==>1596013186122
		主线程结束...Thread[http-nio-8080-exec-4,5,main]==>1596013186124
		副线程开始...Thread[MvcAsync1,5,main]==>1596013186138
		副线程开始...Thread[MvcAsync1,5,main]==>1596013188139
		preHandle.../springmvc_annotation_war/async01
		postHandle...
		afterCompletion...
	*///~

}