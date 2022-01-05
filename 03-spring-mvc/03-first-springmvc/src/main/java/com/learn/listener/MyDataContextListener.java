package com.learn.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Servlet监听器
 */
public class MyDataContextListener implements ServletContextListener {
    private ServletContext context = null;

    public MyDataContextListener(){

    }

    /**
     * 一旦 Web 应用启动的时候，我们就能在任意的 Servlet 或者 JSP 中通过下面的方式获取我们初始化的参数。
     */
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        this.context = servletContextEvent.getServletContext();
        context.setAttribute("myData", "this is myData");
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        String myData = (String) servletContextEvent.getServletContext().getAttribute("myData");
        System.out.println("destroy: " + myData);
        this.context = null;
    }
}
