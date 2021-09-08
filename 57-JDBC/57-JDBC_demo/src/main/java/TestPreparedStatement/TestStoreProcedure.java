package TestPreparedStatement;

import java.sql.*;

/**
 * Java����Ա���Ա��ԡ� 4.11.4 Statement�� PreparedStatement �� CallableStatement ��ʲô����
 *
 * PreparedStatement ��ʾԤ�����SQL���Ķ�������ִ�д�������Ԥ����SQL��䡣
 *
 * ��ȫ�Ը��á�ʹ�� PreparedStatement �ܹ�Ԥ�� SQL ע�빥������ν SQL ע�룬
 * ָ����ͨ���� SQL ������뵽 Web ���ݽ�������������ҳ������Ĳ�ѯ�ַ�������
 * �մﵽ��ƭ���������ﵽִ�ж��� SQL �����Ŀ�ġ�ע��ֻ�� SQL ���ı��������
 * �ƻ����ã���ִ�н׶�ֻ�ǰ����˴���Ϊ���ݴ���������Ҫ�� SQL �����н�������
 * ��Ҳ�ͱ���������
 *     select * from user where name = 'aa'and password = 'bb' or 1=1
 * �� SQL ע������ķ�����
 *
 */
public class TestStoreProcedure {
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
    public static void execProcedure() {
        Connection conn = null; // ���ݿ����Ӷ���
        PreparedStatement stmt = null; // CallableStatement����
        ResultSet res = null; // ���������
        try {
            // ��ȡ���ݿ�����
            conn = getConnection();

            // ���� PreparedStatement ����
            stmt = conn.prepareStatement("SELECT * FROM emp WHERE empno=?");
            stmt.setInt(1,7788); //���ݲ�������һ�����⣬���ݵ�ֵ��

            // ִ��Ԥ������̣�����ȡ�����
            res = stmt.executeQuery();

            // ѭ�����������
            while (res.next()) {
                // ��ȡ��ֵ
                int id = res.getInt("empno");
                String name = res.getString("ename");
                Timestamp hiredate = res.getTimestamp("hiredate");

                // �����ֵ
                System.out.println("��ţ�" + id + "  ������" + name + "  ����ʱ�䣺" + hiredate);
            }

        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } finally {
            // �ر����ݿ��������
            closeOperate(res, stmt, conn);
        }
    }

    public static void main(String[] args) {
        execProcedure();
    }
}
/* Output:
���ݿ��������سɹ�
���ݿ����ӳɹ�
��ţ�7788  ������SCOTT  ����ʱ�䣺1982-12-09 08:00:00.0
�ر����ݿ�����������
 */
