package TestCallableStatement;
import java.sql.*; //����java.sql��

/**
 * ���ô洢����
 * ʾ����ͨ�����ô洢���̣���ȡ�û���ҳ�б�������������ҳ����
 *
 * https://blog.csdn.net/pan_junbiao/article/details/86654993
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
        CallableStatement clbStmt = null; // CallableStatement����
        ResultSet res = null; // ���������
        try {
            // ��ȡ���ݿ�����
            conn = getConnection();

            // ���� CallableStatement ����
            clbStmt = conn.prepareCall("{CALL proc_search_user(?,?,?,?)}");

            // �����������
            clbStmt.setInt(1, 3); // ��ѯ��3ҳ����
            clbStmt.setInt(2, 3); // ÿҳ10������

            // ע���������
            clbStmt.registerOutParameter(3, Types.INTEGER);
            clbStmt.registerOutParameter(4, Types.INTEGER);

            // ִ�е��ô洢���̣�����ȡ�����
            res = clbStmt.executeQuery();

            // ѭ�����������
            while (res.next()) {
                // ��ȡ��ֵ
                int id = res.getInt("empno");
                String name = res.getString("ename");
                Timestamp createTime = res.getTimestamp("hiredate");

                // �����ֵ
                System.out.println("��ţ�" + id + "  ������" + name + "  ����ʱ�䣺" + createTime);
            }

            // ��ȡ�������ֵ
            int totalCount = clbStmt.getInt(3);
            int totalPage = clbStmt.getInt(4);
            System.out.println("����������" + totalCount + " ��ҳ����" + totalPage);

        } catch (SQLException sqle) {
            sqle.printStackTrace();
        } finally {
            // �ر����ݿ��������
            closeOperate(res, clbStmt, conn);
        }
    }

    public static void main(String[] args) {
        execProcedure();
    }
}
/* Output:
���ݿ��������سɹ�
���ݿ����ӳɹ�
��ţ�7782  ������CLARK  ����ʱ�䣺1981-06-09 08:00:00.0
��ţ�7788  ������SCOTT  ����ʱ�䣺1982-12-09 08:00:00.0
��ţ�7839  ������KING  ����ʱ�䣺1981-11-17 08:00:00.0
����������14 ��ҳ����5
�ر����ݿ�����������
 */
