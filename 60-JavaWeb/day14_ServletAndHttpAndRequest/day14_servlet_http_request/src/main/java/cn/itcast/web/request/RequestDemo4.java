package cn.itcast.web.request;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * http://localhost:8080/day14_servlet_http_request_war_exploded/login.html
 */
@WebServlet("/requestDemo4")
public class RequestDemo4 extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //演示获取请求头数据:referer
        String referer = request.getHeader("referer");
        System.out.println(referer); //http://localhost/day14_servlet_http_request_war_exploded/login.html

        //防盗链
        if(referer != null ){
            if(referer.contains("/day14_servlet_http_request_war_exploded")){
                //正常访问
               // System.out.println("播放电影....");
                response.setContentType("text/html;charset=utf-8");
                response.getWriter().write("播放电影....");
            }else{
                //盗链
                //System.out.println("想看电影吗？来优酷吧...");
                response.setContentType("text/html;charset=utf-8");
                response.getWriter().write("想看电影吗？来优酷吧...");
            }
        }
    }
}
/* 浏览器输出：
播放电影....
 */