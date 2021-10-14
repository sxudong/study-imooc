package TestCallableStatement;

import java.sql.*;

/*
在JDBC API中提供了调用存储过程的方法，通过 CallableStatement 对象进行操作。
CallableStatement 对象位于 java.sql 包中，它继承于 PreparedStatement 对象，
PreparedStatement 对象又继承于 Statement 对象。CallableStatement 对象主要
用于执行数据库中定义的存储过程和存储函数，其调用方法如下：
    1)调用存储过程：{call <procedure-name>[(<arg1>,<arg2>, ...)]}
    2)调用存储函数：{?= call <procedure-name>[(<arg1>,<arg2>, ...)]}

CallableStatement对象的常用方法：
   execute()
     执行静态的 SQL 语句，该语句可能返回多个结果集。

   executeQuery()
     执行此 CallableStatement 对象中的 SQL 查询，并返回查询结果集 ResultSet 对象。

   registerOutParameter(int parameterIndex, int sqlType)
     将序号 parameterlndex 中的 OUT 参数 parameterIndex 到 JDBC 类型 sqlType .

   close()
     释放对象的数据库和 JDBC 资源，而不是等待它自动关闭时发生。
 */



/**
 * 调用存储函数
 * 示例：通过调用存储函数，根据用户编号，获取用户姓名。
 *
 * https://blog.csdn.net/pan_junbiao/article/details/86654993
 */
public class TestStoreFunction {
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
     * 调用存储函数
     */
    public static void execFunction() {
        Connection conn = null; // 数据库连接对象
        CallableStatement clbStmt = null; // CallableStatement对象
        try {
            // 获取数据库连接
            conn = getConnection();

            // 创建 CallableStatement 对象
            clbStmt = conn.prepareCall("{?=CALL func_get_user_name(?)}");

            // 注册输出结果参数
            clbStmt.registerOutParameter(1, Types.VARCHAR);

            // 设置输入参数
            clbStmt.setInt(2, 7369);

            // 执行调用存储函数
            clbStmt.execute();

            // 获取输出参数值
            String userName = clbStmt.getString(1);
            System.out.println("用户名称：" + userName);

        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } finally {
            // 关闭数据库操作对象
            closeOperate(null, clbStmt, conn);
        }
    }

    public static void main(String[] args) {
        execFunction();
    }
}
/* Output:
数据库驱动加载成功
数据库连接成功
用户名称：SMITH
关闭数据库操作对象完成
 */
