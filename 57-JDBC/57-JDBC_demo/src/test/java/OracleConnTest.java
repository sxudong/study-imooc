import org.junit.Test;
import testOracleConn.DBUtil;

import java.sql.*;

public class OracleConnTest {
    @Test
    public void testReadTimeout() throws Exception {
        String readTimeout = "0"; // ms
        System.setProperty("oracle.jdbc.ReadTimeout", readTimeout);
        Class.forName("oracle.jdbc.OracleDriver");
        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.56.113:1521:orcl", "scott", "tiger");

        String sql = "SELECT * FROM student";
        PreparedStatement pstmt;
        try {
            pstmt = (PreparedStatement) conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            int col = rs.getMetaData().getColumnCount();
            System.out.println("============================");
            while (rs.next()) {
                for (int i = 1; i <= col; i++) {
                    System.out.print(rs.getObject(i));
                }
                System.out.println("");
            }
            System.out.println("============================");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            //close resources
            DBUtil.closeConnection(conn);
        }
    }
}
