package TestCallableStatement;

import java.sql.*;

/*
��JDBC API���ṩ�˵��ô洢���̵ķ�����ͨ�� CallableStatement ������в�����
CallableStatement ����λ�� java.sql ���У����̳��� PreparedStatement ����
PreparedStatement �����ּ̳��� Statement ����CallableStatement ������Ҫ
����ִ�����ݿ��ж���Ĵ洢���̺ʹ洢����������÷������£�
    1)���ô洢���̣�{call <procedure-name>[(<arg1>,<arg2>, ...)]}
    2)���ô洢������{?= call <procedure-name>[(<arg1>,<arg2>, ...)]}

CallableStatement����ĳ��÷�����
   execute()
     ִ�о�̬�� SQL ��䣬�������ܷ��ض���������

   executeQuery()
     ִ�д� CallableStatement �����е� SQL ��ѯ�������ز�ѯ����� ResultSet ����

   registerOutParameter(int parameterIndex, int sqlType)
     ����� parameterlndex �е� OUT ���� parameterIndex �� JDBC ���� sqlType .

   close()
     �ͷŶ�������ݿ�� JDBC ��Դ�������ǵȴ����Զ��ر�ʱ������
 */



/**
 * ���ô洢����
 * ʾ����ͨ�����ô洢�����������û���ţ���ȡ�û�������
 *
 * https://blog.csdn.net/pan_junbiao/article/details/86654993
 */
public class TestStoreFunction {
    // ���ݿ�����
    public static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    // ���ݿ����ӵ�ַ
    public static final String DB_URL = "jdbc:mysql://localhost:3306/orcl?serverTimezone=UTC";

    // ���ݿ��û�����
    public static final String DB_USER = "root";

    // ���ݿ��û�����
    public static final String DB_PASSWORD = "root";


    /**
     * ��ȡ���ݿ�����
     *
     * @return ���ݿ����Ӷ���
     */
    public static Connection getConnection() {
        Connection conn = null;

        try {
            // �������ݿ�������
            Class.forName(DRIVER_CLASS);
            System.out.println("���ݿ��������سɹ�");

            // ��ȡ���ݿ����Ӷ���
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("���ݿ����ӳɹ�");

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
     * �ر����ݿ��������
     *
     * @param res  ResultSet����
     * @param stmt Statement����
     * @param conn Connection����
     */
    public static void closeOperate(ResultSet res, Statement stmt, Connection conn) {
        try {
            // �ر� ResultSet ����
            if (res != null)
                res.close();

            // �ر�Statement����
            if (stmt != null)
                stmt.close();

            // �ر�Connection����
            if (conn != null)
                conn.close();

            System.out.println("�ر����ݿ�����������");

        } catch (SQLException sqle) {
            sqle.printStackTrace();
        }
    }

    /**
     * ���ô洢����
     */
    public static void execFunction() {
        Connection conn = null; // ���ݿ����Ӷ���
        CallableStatement clbStmt = null; // CallableStatement����
        try {
            // ��ȡ���ݿ�����
            conn = getConnection();

            // ���� CallableStatement ����
            clbStmt = conn.prepareCall("{?=CALL func_get_user_name(?)}");

            // ע������������
            clbStmt.registerOutParameter(1, Types.VARCHAR);

            // �����������
            clbStmt.setInt(2, 7369);

            // ִ�е��ô洢����
            clbStmt.execute();

            // ��ȡ�������ֵ
            String userName = clbStmt.getString(1);
            System.out.println("�û����ƣ�" + userName);

        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } finally {
            // �ر����ݿ��������
            closeOperate(null, clbStmt, conn);
        }
    }

    public static void main(String[] args) {
        execFunction();
    }
}
/* Output:
���ݿ��������سɹ�
���ݿ����ӳɹ�
�û����ƣ�SMITH
�ر����ݿ�����������
 */
