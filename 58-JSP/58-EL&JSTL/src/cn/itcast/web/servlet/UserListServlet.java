package cn.itcast.web.servlet;

import cn.itcast.domain.User;
import cn.itcast.service.UserService;
import cn.itcast.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 黑马《JavaWeb从零到精通IDEA版》- Day16_Cookie&Session
 */
@WebServlet("/userListServlet")
public class UserListServlet extends HttpServlet {

    // 测试：http://localhost:8080/58_EL_JSTL_war_exploded/userListServlet
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //1.调用 UserService 完成查询
        UserService service = new UserServiceImpl();
        List<User> users = service.findAll();
        /**
         * 2.将 list 存入 request 域
         */
        request.setAttribute("users",users);
        //3.转发到 list.jsp
        request.getRequestDispatcher("/list.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }
}
