package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TimeServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        //1.使用request获取请求数据
        //1）请求行
        System.out.println("请求方式：" + req.getMethod());
        System.out.println("访问路径：" + req.getServletPath());
        System.out.println("协议类型：" + req.getProtocol());

        //2）消息头(键值对)
        //Enumeration老版本的迭代器，作用及用法和Iterator类似。
        Enumeration<String> e = req.getHeaderNames();
        while (e.hasMoreElements()) {
            String key = e.nextElement();
            String value = req.getHeader(key);
            System.out.println(key + ":" + value);
        }

        //3）实体内容
        //本案例没有传递具体的业务数据，所以实体内容为空，以后再演示

        //2.使用response发送响应数据
        //1)状态行
        //该数据由服务器自动填充

        //2)消息头
        //消息头中的大部分数据由服务器填充，
        //但返回的内容的格式需要程序员指定。

        //告诉浏览器给它发送的是网页
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        String now = sdf.format(date);

        //3)实体内容
        //我们输出的网页就是实体内容
        out.println("<p>" + now + "<p>");
        out.close();
    }
}
// Tomcat输出：
//请求方式：GET
//访问路径：/ts
//协议类型：HTTP/1.1
//host:localhost:8080
//connection:keep-alive
//sec-ch-ua:"Microsoft Edge";v="93", " Not;A Brand";v="99", "Chromium";v="93"
//sec-ch-ua-mobile:?0
//sec-ch-ua-platform:"Windows"
//upgrade-insecure-requests:1
//user-agent:Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36 Edg/93.0.961.38
//accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
//sec-fetch-site:none
//sec-fetch-mode:navigate
//sec-fetch-user:?1
//sec-fetch-dest:document
//accept-encoding:gzip, deflate, br
//accept-language:zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
