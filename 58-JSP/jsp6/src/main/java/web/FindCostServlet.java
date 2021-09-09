package web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 测试过滤
 * http://localhost:8080/jsp6_war_exploded/findCost
 */
public class FindCostServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		//模拟查询
		System.out.println("查询资费");
	}
}
/* Tomcat输出：
在前面记日志
在前面过滤敏感词
北京
查询资费
在后面过滤敏感词
在后面记日志
 */