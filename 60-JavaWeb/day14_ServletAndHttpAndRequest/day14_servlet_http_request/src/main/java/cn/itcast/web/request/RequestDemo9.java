package cn.itcast.web.request;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * http://localhost:8080/day14_servlet_http_request_war_exploded/requestDemo9
 */
@WebServlet("/requestDemo9")
public class RequestDemo9 extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //获取数据
        Object msg = request.getAttribute("msg");
        System.out.println(msg);

        System.out.println("demo9999被访问了。。。");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        this.doPost(request,response);
    }
}
/* output:
null
demo9999被访问了。。。
 */
