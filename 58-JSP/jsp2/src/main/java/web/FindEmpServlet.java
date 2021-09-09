package web;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.EmpDao;
import dao.EmpDaoImpl;
import entity.Emp;


public class FindEmpServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		//不删除会要求重写doGet，doSet方法
		//super.service(arg0, arg1);

		//处理业务（查询）
		EmpDao dao = new EmpDaoImpl();
		List<Emp> list = dao.findAll();
		//转发：让jsp继续完成这个请求
		//1）将数据绑定到request上
		req.setAttribute("emps",list);
		//2）将请求提交给jsp让它继续处理，
		//同时要将处理请求的工具给jsp。
		//工具：request+response
		//当前：/jsp2/findEmp
		//目标：/jsp2/emp_list.jsp
		req.getRequestDispatcher("emp_list.jsp").forward(req, res);
	}
}