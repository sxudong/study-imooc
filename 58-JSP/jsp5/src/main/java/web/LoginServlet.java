package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 登录
 *
 * 输入登录URL，参数code，servlet后返回新创建的Cookie
 * http://localhost:8080/jsp5_war_exploded/main/login?code=1
 */
public class LoginServlet extends HttpServlet {
	//1.浏览器首次访问时，服务器会自动给它创建一个session。
	//2.服务器在创建request后，会让request引用这个session。
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		//接收账号
		String code = req.getParameter("code");

		//getSession()获取，存入session
		HttpSession session = req.getSession();

		//session的内部可以存储任意类型的数据，并且大小、个数不受限制.
		session.setAttribute("code", code);
		/*
		 * 响应时服务器会自动创建cookie,
		 * 将session的ID通过cookie发送给浏览器。
		 * Cookie c = new Cookie(
		 *             "JSESSIONID",session.getId());
		 *  "JSESSIONID"中的"J"代表java语言中的session
		 */
	}
}