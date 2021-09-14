package cn.itcast.web.servlet;


//import redis.clients.jedis.Jedis;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


@WebServlet("/demo")
public class DemoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("Hello Maven Servlet~~~~");

        try {
            Connection conn = DriverManager.getConnection("","","");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //Jedis jedis = new Jedis();
    }
}
