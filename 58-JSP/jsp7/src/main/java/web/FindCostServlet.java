package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FindCostServlet extends HttpServlet {

	@Override
	protected void service(
			HttpServletRequest req,
			HttpServletResponse res)
			throws ServletException, IOException {
		//模拟查询
		System.out.println("查询资费");
	}
}
