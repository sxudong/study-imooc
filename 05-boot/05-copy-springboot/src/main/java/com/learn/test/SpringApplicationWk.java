package com.learn.test;

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.startup.Tomcat;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import java.io.File;

/**
 * 在 Spring 源码项目中创建使用 SpringMVC 功能模块
 * https://www.cnblogs.com/wk-missQ1/p/13283985.html
 */
public class SpringApplicationWk {
    public static void run() throws ServletException, LifecycleException {
        // 直接初始化 spring 容器
        AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
		context.register(Appconfig.class);
		context.refresh();

        File base = new File(System.getProperty("java.io.tmpdir"));
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(9090);


        /**
         * addWebapp 表示这是一个 web 项目
         * contextPath Tomcat的访问路径
         * 项目的 web 目录
         * 所以这里不能用 addWebapp (SpringBoot当中也没有这么做)
         *
         */
//        tomcat.addWebapp("/","index.html");
        Context rootContext = tomcat.addContext("/", base.getAbsolutePath());

        DispatcherServlet dispatcherServlet = new DispatcherServlet(context);

        // 这段话的作用是在 Tomcat 的启动过程中会调用 DispatcherServlet.init() 方法
        // 初始化 controller 和请求映射
        Tomcat.addServlet(rootContext,"wk", (Servlet) dispatcherServlet).setLoadOnStartup(1);
//        rootContext.addServletMapping("/","wk");
        rootContext.addServletMappingDecoded("/","wk");
        tomcat.start();
        tomcat.getServer().await();
    }
}