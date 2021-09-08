package Test_RoolBack;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * 设置手动提交，有一条错误，执行了事物回滚
 */
public class Demo_RoolBack2 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        String url = "jdbc:mysql://localhost:3306/orcl?serverTimezone=UTC";
        String user = "root";
        String password = "root";
        String driver = "com.mysql.cj.jdbc.Driver"; //旧版驱动 com.mysql.jdbc.Driver

        //4.创建sql命令(小王给小明转1000元)
        String sql1 = "update emp set sal=sal-1000 where empno=7788"; //SCOTT减少1000元
        String sql2 = "update emp set sal=sal+1000 where empno=8888"; //KING增加1000元  没有编号8888

        //1.加载驱动包
        Class.forName(driver);
        //2.获取数据库连接对象
        Connection conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); //设置手动提交
        //3.连接sql命令对象
        Statement state = conn.createStatement();
        //5.执行sql命令
        int i = state.executeUpdate(sql1);
        int j = state.executeUpdate(sql2);
        System.out.println(i + "------" + j);

        if (i > 0 && j > 0) {
            conn.commit();
        } else {
            conn.rollback();
        }

        //6.关闭相关资源
        state.close();
        conn.close();
    }
}
/* Output:
1------0

# 执行后 SCOTT 的 sal=3000.00 没有变，有一条错误，事务回滚了。
mysql> SELECT * FROM emp WHERE empno='7788';
+-------+-------+---------+------+---------------------+---------+------+--------+
| empno | ename | job     | mgr  | hiredate            | sal     | comm | deptno |
+-------+-------+---------+------+---------------------+---------+------+--------+
|  7788 | SCOTT | ANALYST | 7566 | 1982-12-09 00:00:00 | 2000.00 | NULL |     20 |
+-------+-------+---------+------+---------------------+---------+------+--------+
1 row in set (0.00 sec)
*/