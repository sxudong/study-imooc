package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entity.Course;
import entity.Student;

public class FindStudentServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		//1.获取参数（略）

		//2.处理数据
		//模拟查询学生
		//step1.NEW Student
		Student stu = new Student();
		stu.setName("zhangsan");
		stu.setAge(25);
		stu.setSex("M");
		stu.setInterests(new String[]{"篮球","足球","排球","画"});

		//step1.NEW Course
		Course c = new Course();
		c.setId(1);
		c.setCourseName("Java");
		c.setDays(80);

		//step3
		stu.setCourse(c);

		//3.转发或重定向
		req.setAttribute("stu", stu);
		//当前：/Jsp3/findStudent
		//目标：/Jsp3/find_student.jsp
		req.getRequestDispatcher("find_student.jsp").forward(req, res);
	}
}