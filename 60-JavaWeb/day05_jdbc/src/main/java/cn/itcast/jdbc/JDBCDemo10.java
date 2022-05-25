package cn.itcast.jdbc;

import cn.itcast.util.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * 事务操作（JDBC中的事务）
 *
 * Connection 接口的 api:
 * setAutoComit(boolean autocommit)  参数为 false，表示关闭自动提交，相当于开启事务;类似 sql里面的 start transaction
 * void commit()     提交事务; 类似 sql 里面的 commit;
 * void rollback()   回滚事务; 类似 sql 里面的 rollback;
 *
 * 1、JDBC 程序中当一个 Connection 对象创建时，默认情况下是自动提交事务。每次执行一个 sql 语句时，如果执行成功，就会向数据库自动提交，而不能回滚
 * 2、JDBC 程序中为了让多个 sql 语句作为一个整体执行，需要使用事务
 * 3、调用 Connection 的 setAutoCommit（false）可以取消自动提交事务
 * 4、在所有的 sql 语句都成功执行后，调用 Connection 的 comit（）方法提交事务
 * 5、在其中某个操作失败或出现异常时，调用 Connection 的 rollback 方法回滚事务
 *
 * start transaction; // 开启事务
 *
 * update account set money = money - 100 where `name` = 'A';  // 执行sql语句
 * update account set money = money + 100 where `name` = 'B';
 *
 * commit; // 提交事务
 * ————————————————
 * 版权声明：本文为CSDN博主「东临碣石_观沧海」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
 * 原文链接：https://blog.csdn.net/weixin_43573264/article/details/120169755
 */
public class JDBCDemo10 {
    public static void main(String[] args) {

        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            // 1.获取连接对象
            conn = JDBCUtils.getConnection();
            // 开启事务,即将自动提交事务关闭
            conn.setAutoCommit(false);

            // 2.定义sql
            // 2.1 张三 - 500
            String sql1 = "update account set balance = balance - ? where id = ?";
            // 2.2 李四 + 500
            String sql2 = "update account set balance = balance + ? where id = ?";
            // 3.获取执行sql对象
            pstmt1 = conn.prepareStatement(sql1);
            pstmt2 = conn.prepareStatement(sql2);
            //4. 设置参数
            pstmt1.setDouble(1,500);
            pstmt1.setInt(2,1);

            pstmt2.setDouble(1,500);
            pstmt2.setInt(2,2);
            // 5.执行sql
            pstmt1.executeUpdate();
            // 手动制造异常
            int i = 3/0;

            pstmt2.executeUpdate();
            // 6.提交事务
            conn.commit();
        } catch (Exception e) {
            // 7.若出现异常则回滚事务
            try {
                if(conn != null) {
                    conn.rollback();
                }
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
            e.printStackTrace();
        }finally {
            JDBCUtils.close(pstmt1,conn);
            JDBCUtils.close(pstmt2,null);
        }
    }
}
/* Output:
java.lang.ArithmeticException: / by zero
	at cn.itcast.jdbc.JDBCDemo10.main(JDBCDemo10.java:42)
 */