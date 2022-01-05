package com.learn.servlet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 《Spring源码深度解析》P301 Servlet的使用
 *  JSP 的本质就是 Servlet.
 */
public class MyServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        System.out.println("This is init method");
    }

    public void doGet(HttpServletRequest req, HttpServletResponse resp){
        handleLogic(req,resp);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp){
        handleLogic(req,resp);
    }

    // http://localhost:8080/03_first_springmvc_war/myservlet.htm
    private void handleLogic(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("handle myLogic");
        ServletContext sc = getServletContext();

        /**
         * 将 jsp 转换为 Java
         */
        RequestDispatcher rd = sc.getRequestDispatcher("/index.jsp"); // 页面跳转至index.jsp
        try {
            rd.forward(req, resp);
        } catch (ServletException | IOException e) {
            e.printStackTrace();
        }
    }
}
