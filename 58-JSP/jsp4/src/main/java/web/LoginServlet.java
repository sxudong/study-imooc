package web;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录检查，判断账号密码是否正确
 * 相当于 NETCTOSS电信项目 中的 MainServlet.login()
 *
 * 输入登录URL，参数code，servlet后返回新创建的Cookie
 * http://localhost:8080/jsp4_war_exploded/main/login?code=1
 */
public class LoginServlet extends HttpServlet {
	//1.模拟登录验证功能。
	//2.接收用户输入的账号。
	//3.将其存入cookie。
	//4.将cookie发送给浏览器。
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		//接收参数（用户输入的账号密码）。
		String code = req.getParameter("code");
		//检查账号密码
		//转发重定向

		//给发起本次请求的浏览器创建cookie。
		//检查通过后，将账号存入cookie
		//每个cookie对象只能存一条数据，包括key和value，都是字符串
		Cookie c1 = new Cookie("code", code);

		//声明cookie的生存时间：
		//>0时cookie保存在客户端的硬盘上；
		//=0时，cookie被浏览器删除
		c1.setMaxAge(600000);

		//设置cookie的有效路径
		//cookie将在此路径以及它的下级路径下都有效。
		c1.setPath("/jsp4_war_exploded");

		//将cookie发送给浏览器，浏览器接收到以后，会自动保存
		res.addCookie(c1);

		//再创建一个cookie，保存中文。
		//保存前必须对中文转码(ASKII)。
		Cookie c2 = new Cookie("city", URLEncoder.encode("北京", "utf-8"));
		res.addCookie(c2);
	}
}