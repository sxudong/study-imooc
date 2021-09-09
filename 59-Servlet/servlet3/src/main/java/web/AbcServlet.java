package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AbcServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		//通过不同的方法获取访问路径的不同部位
		System.out.println(req.getContextPath());
		System.out.println(req.getServletPath());
		System.out.println(req.getRequestURI());
		System.out.println(req.getRequestURL());

		//如果没有写响应信息，服务器依然会自动向浏览器发送响应，
		//只是响应的数据为空而已，浏览器会看到一片空白，并不会报错。
	}
}
/* http://localhost:8080/servlet3_war_exploded/a.duang Tomcat输出：
/servlet3_war_exploded
/a.duang
/servlet3_war_exploded/a.duang
http://localhost:8080/servlet3_war_exploded/a.duang
 */