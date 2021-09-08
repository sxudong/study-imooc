package TestCallableStatement;
import java.sql.*; //导入java.sql包

/**
 * 调用存储过程
 * 示例：通过调用存储过程，获取用户分页列表，数据总数和总页数。
 *
 * https://blog.csdn.net/pan_junbiao/article/details/86654993
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
     * 调用存储过程
     */
    public static void execProcedure() {
        Connection conn = null; // 数据库连接对象
        CallableStatement clbStmt = null; // CallableStatement对象
        ResultSet res = null; // 结果集对象
        try {
            // 获取数据库连接
            conn = getConnection();

            // 创建 CallableStatement 对象
            clbStmt = conn.prepareCall("{CALL proc_search_user(?,?,?,?)}");

            // 设置输入参数
            clbStmt.setInt(1, 3); // 查询第3页数据
            clbStmt.setInt(2, 3); // 每页10条数据

            // 注册输出参数
            clbStmt.registerOutParameter(3, Types.INTEGER);
            clbStmt.registerOutParameter(4, Types.INTEGER);

            // 执行调用存储过程，并获取结果集
            res = clbStmt.executeQuery();

            // 循环遍历结果集
            while (res.next()) {
                // 获取列值
                int id = res.getInt("empno");
                String name = res.getString("ename");
                Timestamp createTime = res.getTimestamp("hiredate");

                // 输出列值
                System.out.println("编号：" + id + "  姓名：" + name + "  生日时间：" + createTime);
            }

            // 获取输出参数值
            int totalCount = clbStmt.getInt(3);
            int totalPage = clbStmt.getInt(4);
            System.out.println("数据总数：" + totalCount + " 总页数：" + totalPage);

        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } finally {
            // 关闭数据库操作对象
            closeOperate(res, clbStmt, conn);
        }
    }

    public static void main(String[] args) {
        execProcedure();
    }
}
/* Output:
数据库驱动加载成功
数据库连接成功
编号：7782  姓名：CLARK  生日时间：1981-06-09 08:00:00.0
编号：7788  姓名：SCOTT  生日时间：1982-12-09 08:00:00.0
编号：7839  姓名：KING  生日时间：1981-11-17 08:00:00.0
数据总数：14 总页数：5
关闭数据库操作对象完成
 */
