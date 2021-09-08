package Test_RoolBack;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * �����ֶ��ύ����һ������ִ��������ع�
 */
public class Demo_RoolBack2 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        String url = "jdbc:mysql://localhost:3306/orcl?serverTimezone=UTC";
        String user = "root";
        String password = "root";
        String driver = "com.mysql.cj.jdbc.Driver"; //�ɰ����� com.mysql.jdbc.Driver

        //4.����sql����(С����С��ת1000Ԫ)
        String sql1 = "update emp set sal=sal-1000 where empno=7788"; //SCOTT����1000Ԫ
        String sql2 = "update emp set sal=sal+1000 where empno=8888"; //KING����1000Ԫ  û�б��8888

        //1.����������
        Class.forName(driver);
        //2.��ȡ���ݿ����Ӷ���
        Connection conn = DriverManager.getConnection(url, user, password);
        conn.setAutoCommit(false); //�����ֶ��ύ
        //3.����sql�������
        Statement state = conn.createStatement();
        //5.ִ��sql����
        int i = state.executeUpdate(sql1);
        int j = state.executeUpdate(sql2);
        System.out.println(i + "------" + j);

        if (i > 0 && j > 0) {
            conn.commit();
        } else {
            conn.rollback();
        }

        //6.�ر������Դ
        state.close();
        conn.close();
    }
}
/* Output:
1------0

# ִ�к� SCOTT �� sal=3000.00 û�б䣬��һ����������ع��ˡ�
mysql> SELECT * FROM emp WHERE empno='7788';
+-------+-------+---------+------+---------------------+---------+------+--------+
| empno | ename | job     | mgr  | hiredate            | sal     | comm | deptno |
+-------+-------+---------+------+---------------------+---------+------+--------+
|  7788 | SCOTT | ANALYST | 7566 | 1982-12-09 00:00:00 | 2000.00 | NULL |     20 |
+-------+-------+---------+------+---------------------+---------+------+--------+
1 row in set (0.00 sec)
*/