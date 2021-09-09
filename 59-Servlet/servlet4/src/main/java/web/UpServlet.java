package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * http://localhost:8080/servlet4_war_exploded/up
 */
public class UpServlet extends HttpServlet {
	private double salary = 2000.0;

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		//加锁
		synchronized (this) {
			//模拟涨薪
			salary += 100;

			//模拟网络延迟
			try {
				Thread.sleep(8000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

			//显示最新的工资
			res.setContentType("text/html");
			PrintWriter out = res.getWriter();
			out.println(salary);
			out.close();
		}
	}
}
/* 浏览器输出：
2100.0
 */