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

        /**
         * 5��������뼶��
         *   1��TRANSACTION_NONE ˵����֧������
         *
         *   2��TRANSACTION_READ_UNCOMMITTED δ�ύ��
         *     ˵�����ύǰһ��������Կ�����һ������ı仯��������������������ظ��Ķ��������������ġ�
         *
         *   3��TRANSACTION_READ_COMMITTED ���ظ���
         *     ˵����ȡδ�ύ�������ǲ�����ġ����������Ȼ�������ظ��Ķ������������
         *
         *   4��TRANSACTION_REPEATABLE_READ ���ظ��� (MySQLĬ��)
         *     ˵������֤�ܹ��ٴζ�ȡ��ͬ�����ݶ�����ʧ�ܣ��������Ȼ����֡�
         *
         *   5��TRANSACTION_SERIALIZABLE �����л�
         *     ����ߵ����񼶱�����ֹ����������ظ��Ķ��������
         *
         * ��ע:
         *    1�������ࡱ���ݡ�һ�������ȡ����-��������δ�ύ�����ݣ����磬������A������B����ִ��ʱ��������A���º�
         *    ����B��ѯ��ȡ��A��δ�ύ�����ݣ���ʱ����A�ع���������B��������������Ч�ġ��ࡱ���ݡ�
         *
         *    2�������ظ�����һ������Ĳ���������һ������ǰ�����ζ�ȡ����ͬ�����ݣ����磬������A������B����ִ��ʱ��
         *    ������B��ѯ��ȡ���ݺ�����A���²�����������B��ѯ�������ݣ���ʱ����B�ٴζ�ȥ�����ݣ�����ǰ�����ε���
         *    �ݲ�һ����
         *
         *    3�������һ������Ĳ���������һ������ǰ�����β�ѯ�Ľ����������ͬ�����磬������A������B����ִ��ʱ����
         *    ����B��ѯ��ȡ���ݺ�����A������ɾ����һ����������A �Ĳ�ѯ�����ļ�¼����ʱ������B�ٴβ�ѯ�����ֲ�ѯ��
         *    ǰ�β����ڵļ�¼,����ǰ�ε�ĳ����¼�����ˡ�)
         *
         * ������뼶��Խ�ߣ�Ϊ�����ͻ�����ľ���Ҳ��Խ�ࡣ����ͨ�� Connection ����� conn. setTransactionLevel()
         * ���������ø��뼶��ͨ�� conn. getTransactionIsolation() ������ȷ����ǰ����ļ���
         */

        // ������Ҫ�����񼶱�
        conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); ;

        // ����ͨ������ķ���ȷ����ǰ����ļ���
        int level = conn.getTransactionIsolation();
        if(level == Connection.TRANSACTION_NONE)                  // ��֧������
            System.out.println("TRANSACTION_NONE");
        else if(level == Connection.TRANSACTION_READ_UNCOMMITTED) //δ�ύ��
            System.out.println("TRANSACTION_READ_UNCOMMITTED");
        else if(level == Connection.TRANSACTION_READ_COMMITTED)   //���ظ���
            System.out.println("TRANSACTION_READ_COMMITTED");
        else if(level == Connection.TRANSACTION_REPEATABLE_READ)  //���ظ��� (MySQLĬ��)
            System.out.println("TRANSACTION_REPEATABLE_READ");
        else if(level == Connection.TRANSACTION_SERIALIZABLE)     //�����л�
            System.out.println("TRANSACTION_SERIALIZABLE");

        //6.�ر������Դ
        state.close();
        conn.close();
    }
}
/* Output:
1------0
TRANSACTION_SERIALIZABLE

# ִ�к� SCOTT �� sal=3000.00 û�б䣬��һ����������ع��ˡ�
mysql> SELECT * FROM emp WHERE empno='7788';
+-------+-------+---------+------+---------------------+---------+------+--------+
| empno | ename | job     | mgr  | hiredate            | sal     | comm | deptno |
+-------+-------+---------+------+---------------------+---------+------+--------+
|  7788 | SCOTT | ANALYST | 7566 | 1982-12-09 00:00:00 | 2000.00 | NULL |     20 |
+-------+-------+---------+------+---------------------+---------+------+--------+
1 row in set (0.00 sec)
*/