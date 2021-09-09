package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * 模拟查询资费
 * 相当于 NETCTOSS电信项目 中的 MainServlet.findCost()
 *
 * http://localhost:8080/jsp4_war_exploded/cost/find
 */
public class FindCostServlet extends HttpServlet {
	//1.模拟查询资费功能。
	//2.默认浏览器不会传入c1。
	//3.需要修改cookie的生效路径后才能传入。
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		//模拟查询资费（略）
		//获取Cookie中的账号，并将其输出
		Cookie [] cs = req.getCookies();
		if(cs != null){
			res.setContentType
					("text/html;charset=utf-8");
			PrintWriter out = res.getWriter();
			for(Cookie c:cs) {
				out.println(c.getName()+":"+c.getValue());
			}
			out.close();
		}
	}
}
/* 浏览器端显示，这个是登录时用户输入的参数code。
code:1
 */