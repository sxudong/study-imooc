package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * 模拟打开主页
 *
 * http://localhost:8080/jsp5_war_exploded/main/index
 */
public class IndexServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		//由于本次请求浏览器传入了SID,服务器就根据SID找
		//到那个旧的session，可以从中读取之前存的数据。
		HttpSession session = req.getSession();
		String code = (String) session.getAttribute("code");

		//将此数据显示给浏览器
		res.setContentType("text/html;charset=utf-8");
		PrintWriter out = res.getWriter();
		out.println(code);
		out.close();
	}
}
/* 浏览器端返回显示code的值：
1
 */