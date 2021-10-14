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

        /**
         * 5种事物隔离级别：
         *   1）TRANSACTION_NONE 说明不支持事务。
         *
         *   2）TRANSACTION_READ_UNCOMMITTED 未提交读
         *     说明在提交前一个事务可以看到另一个事务的变化。这样“脏读”、不可重复的读和虚读都是允许的。
         *
         *   3）TRANSACTION_READ_COMMITTED 可重复读
         *     说明读取未提交的数据是不允许的。这个级别仍然允许不可重复的读和虚读产生。
         *
         *   4）TRANSACTION_REPEATABLE_READ 可重复读 (MySQL默认)
         *     说明事务保证能够再次读取相同的数据而不会失败，但虚读仍然会出现。
         *
         *   5）TRANSACTION_SERIALIZABLE 可序列化
         *     是最高的事务级别，它防止脏读、不可重复的读和虚读。
         *
         * 备注:
         *    1、读“脏”数据。一个事务读取了另-个事务尚未提交的数据，例如，当事务A与事务B并发执行时，当事务A更新后，
         *    事务B查询读取到A尚未提交的数据，此时事务A回滚，则事务B读到的数据是无效的“脏”数据。
         *
         *    2、不可重复读。一个事务的操作导致另一个事务前后两次读取到不同的数据，例如，当事务A与事务B并发执行时，
         *    当事务B查询读取数据后，事务A更新操作更改事务B查询到的数据，此时事务B再次读去该数据，发现前后两次的数
         *    据不一样。
         *
         *    3、虚读。一个事务的操作导致另一个事务前后两次查询的结果数据量不同，例如，当事务A与事务B并发执行时，当
         *    事务B查询读取数据后，事务A新增或删除了一条满足事务A 的查询条件的记录，此时，事务B再次查询，发现查询到
         *    前次不存在的记录,或者前次的某个记录不见了。)
         *
         * 事务隔离级别越高，为避免冲突所花的精力也就越多。可以通过 Connection 对象的 conn. setTransactionLevel()
         * 方法来设置隔离级别，通过 conn. getTransactionIsolation() 方法来确定当前事务的级别。
         */

        // 设置想要的事务级别
        conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); ;

        // 可以通过下面的方法确定当前事务的级别：
        int level = conn.getTransactionIsolation();
        if(level == Connection.TRANSACTION_NONE)                  // 不支持事务
            System.out.println("TRANSACTION_NONE");
        else if(level == Connection.TRANSACTION_READ_UNCOMMITTED) //未提交读
            System.out.println("TRANSACTION_READ_UNCOMMITTED");
        else if(level == Connection.TRANSACTION_READ_COMMITTED)   //可重复读
            System.out.println("TRANSACTION_READ_COMMITTED");
        else if(level == Connection.TRANSACTION_REPEATABLE_READ)  //可重复读 (MySQL默认)
            System.out.println("TRANSACTION_REPEATABLE_READ");
        else if(level == Connection.TRANSACTION_SERIALIZABLE)     //可序列化
            System.out.println("TRANSACTION_SERIALIZABLE");

        //6.关闭相关资源
        state.close();
        conn.close();
    }
}
/* Output:
1------0
TRANSACTION_SERIALIZABLE

# 执行后 SCOTT 的 sal=3000.00 没有变，有一条错误，事务回滚了。
mysql> SELECT * FROM emp WHERE empno='7788';
+-------+-------+---------+------+---------------------+---------+------+--------+
| empno | ename | job     | mgr  | hiredate            | sal     | comm | deptno |
+-------+-------+---------+------+---------------------+---------+------+--------+
|  7788 | SCOTT | ANALYST | 7566 | 1982-12-09 00:00:00 | 2000.00 | NULL |     20 |
+-------+-------+---------+------+---------------------+---------+------+--------+
1 row in set (0.00 sec)
*/