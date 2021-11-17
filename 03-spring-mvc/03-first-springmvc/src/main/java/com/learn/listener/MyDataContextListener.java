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
