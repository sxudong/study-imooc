package TestPreparedStatement;

import java.sql.*;

/**
 * Java程序员面试笔试》 4.11.4 Statement、 PreparedStatement 和 CallableStatement 有什么区别
 *
 * PreparedStatement 表示预编译的 SQL 语句的对象，用于执行带参数的预编译 SQL 语句。
 *
 * 安全性更好。使用 PreparedStatement 能够预防 SQL 注入攻击。所谓 SQL 注入，
 * 指的是通过把 SQL 命令插入到 Web 表单递交或输入域名或页面请求的查询字符串，最
 * 终达到欺骗服务器，达到执行恶意 SQL 命令的目的。注入只对 SQL 语句的编译过程有
 * 破坏作用，而执行阶段只是把输人串作为数据处理，不再需要对 SQL 语句进行解析，因
 * 此也就避免了类似
 *     select * from user where name = 'aa'and password = 'bb' or 1=1
 * 的 SQL 注入问题的发生。
 *
 */
public class TestStoreProcedure {
    // 数据库驱动
    public static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    // 数据库连接地址
    public static final String DB_URL = "jdbc:mysql://localhost:3306/orcl?serverTimezone=UTC";

    // 数据库用户名称
    public static final String DB_USER = "root";

    // 数据库用户密码
    public static final String DB_PASSWORD = "root";


    /**
     * 获取数据库连接
     *
     * @return 数据库连接对象
     */
    public static Connection getConnection() {
        Connection conn = null;

        try {
            // 加载数据库驱动类
            Class.forName(DRIVER_CLASS);
            System.out.println("数据库驱动加载成功");

            // 获取数据库连接对象
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("数据库连接成功");

        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return conn;
    }

    /**
     * 关闭数据库操作对象
     *
     * @param res  ResultSet对象
     * @param stmt Statement对象
     * @param conn Connection对象
     */
    public static void closeOperate(ResultSet res, Statement stmt, Connection conn) {
        try {
            // 关闭 ResultSet 对象
            if (res != null)
                res.close();

            // 关闭Statement对象
            if (stmt != null)
                stmt.close();

            // 关闭Connection对象
            if (conn != null)
                conn.close();

            System.out.println("关闭数据库操作对象完成");

        } catch (SQLException sqle) {
            sqle.printStackTrace();
        }
    }

    /**
     * 使用 PreparedStatement 查询SQL
     */
    public static void execPreparedStatement() {
        Connection conn = null; // 数据库连接对象
        PreparedStatement stmt = null; // CallableStatement对象
        ResultSet res = null; // 结果集对象
        try {
            // 获取数据库连接
            conn = getConnection();

            // 创建 PreparedStatement 对象
            stmt = conn.prepareStatement("SELECT * FROM emp WHERE empno=?");
            stmt.setInt(1,7788); //传递参数（第一个问题，传递的值）

            // 执行预编译过程，并获取结果集
            res = stmt.executeQuery();

            // 循环遍历结果集
            while (res.next()) {
                // 获取列值
                int id = res.getInt("empno");
                String name = res.getString("ename");
                Timestamp hiredate = res.getTimestamp("hiredate");

                // 输出列值
                System.out.println("编号：" + id + "  姓名：" + name + "  生日时间：" + hiredate);
            }

        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } finally {
            // 关闭数据库操作对象
            closeOperate(res, stmt, conn);
        }
    }

    public static void main(String[] args) {
        execPreparedStatement();
    }
}
/* Output:
数据库驱动加载成功
数据库连接成功
编号：7788  姓名：SCOTT  生日时间：1982-12-09 08:00:00.0
关闭数据库操作对象完成
 */
