package web;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

/**
 * 该 Servlet 不负责处理具体的业务，只用来在 tomcat 启动时初始化数据。
 * 一般 WEB 项目都有 1-2 个这样的 Servlet。
 */
public class InitServlet extends HttpServlet {

	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		// tomcat 启动时会优先创建 context, 然后再创建 Servlet.
		ServletContext ctx = getServletContext();
		//流量默认为0
		ctx.setAttribute("count", 0);
	}
}