package web;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * http://localhost:8080/servlet4_war_exploded/login
 */
public class LoginServlet extends HttpServlet {
	//tomcat创建Servlet的逻辑：
	//LoginServlet s = new LoginServlet();
	//ServletConfig c = new ServletConfig();
	//c.加载数据（）;//从web.xml加载数据
	//s.init(c)
	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		String maxOnline = config.getInitParameter("maxOnline");
		System.out.println(maxOnline);
	}

	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {

		//此config就是init()传入的那个
		ServletConfig cfg = getServletConfig();
		String maxOnline = cfg.getInitParameter("maxOnline");
		System.out.println(maxOnline);
		System.out.println("正在登录...");
	}
}
/* tomcat输出：
3000          //这个3000是在web.xml中初始化的
正在登录...
 */