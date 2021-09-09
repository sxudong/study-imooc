package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 模拟打开主页
 * 相当于 NETCTOSS电信项目 中的 MainServlet.toIndex()
 *
 * 访问首页URL，返回登录Servlet中返回的 cookie
 * http://localhost:8080/jsp4_war_exploded/main/index
 */
public class IndexServlet extends HttpServlet {
    //1.模拟主页功能。
    //2.在此之前用户一定登录过。
    //3.浏览器已经保存了cookie，含账号信息。
    //4.浏览器访问本功能时会自动传入cookie。
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        //向浏览器输出主页的内容（略）
        //获取发起本次请求的浏览器上保存的所有cookie。
        Cookie[] cs = req.getCookies();
        //将他们也输出给浏览器
        if (cs != null) {
            res.setContentType("text/html;charset=utf-8");
            PrintWriter out = res.getWriter();
            for (Cookie c : cs) {
                out.println(c.getName() + ":" + URLDecoder.decode(c.getValue(), "utf-8") + "<br>");
            }
        }
    }
}
/* 浏览器显示，这个是服务器端创建的cookie，并携带了用户登录时输入的code。
city:北京
code:1
 */