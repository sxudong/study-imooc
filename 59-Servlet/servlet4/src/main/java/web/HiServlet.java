package web;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * http://localhost:8080/servlet4_war_exploded/hi
 * tomcat输出：调用HiServlet处理请求
 */
public class HiServlet extends HttpServlet {
	public HiServlet() {
		System.out.println("实例化HiServlet");
	}

	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		System.out.println("初始化HiServlet");
	}

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		System.out.println("调用HiServlet处理请求");
	}

	@Override
	public void destroy() {
		super.destroy();
		System.out.println("销毁HiServlet");
	}
}
