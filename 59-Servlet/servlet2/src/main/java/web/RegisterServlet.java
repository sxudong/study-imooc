package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		req.setCharacterEncoding("utf-8");
		//处理请求的一般步骤是：
		//1.接受参数
		String user = req.getParameter("userName");
		String pwd = req.getParameter("pwd");
		String sex = req.getParameter("sex");
		String[] interests = req.getParameterValues("interest");

		//2.处理业务
		//常规的注册业务应该保存这些数据，
		//但本案例重点在于传参，因此就不存了。
		//解决请求乱码
		//byte[] bs = user.getBytes("iso8859-1");
		//user = new String(bs, "utf-8");
		//将其存入数据库
		System.out.println(user);
		System.out.println(pwd);
		System.out.println(sex);
		if(interests != null) {
			for(String interest : interests) {
				System.out.println(interest);
			}
		}

		//3.发送响应
		res.setContentType("text/html;charset=utf-8");
		PrintWriter out = res.getWriter();
		out.println("<p>注册成功</p>");
		out.close();
	}
}
/* Tomcat输出：
Aaron
123456
M
qin
qi
book
picture
 */
