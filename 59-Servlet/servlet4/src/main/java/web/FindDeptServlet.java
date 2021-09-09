package web;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * http://localhost:8080/servlet4_war_exploded/findDept
 */
public class FindDeptServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		// tomcat 启动时就会创建唯一的 context，
		// 并且会调用它的方法加载 web.xml 中的公用参数，
		// context 是全局的，任何 Servlet 都可以使用。
		ServletContext ctx = getServletContext();
		String size = ctx.getInitParameter("size");  //size是在web.xml中初始的公共数据
		System.out.println(size);
		System.out.println("分页查询部分数据");

		//统计流量
		Integer count = (Integer)ctx.getAttribute("count");
		ctx.setAttribute("count", ++count);
		System.out.println(count);
	}
}
/* Tomcat输出：
20
分页查询部分数据
1
 */