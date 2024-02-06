import oracle.jdbc.pool.OracleDataSource;
import org.junit.Test;
import testOracleConn.DBUtil;

import java.sql.*;
import java.util.Properties;

public class OracleConnTest {
    @Test
    public void testReadTimeout() throws Exception {
        Properties prop = new Properties();
        prop.setProperty("user" , "scott");
        prop.setProperty("password" , "tiger");
        prop.setProperty("oracle.net.CONNECT_TIMEOUT" , "10000000");
        prop.setProperty("oracle.jdbc.ReadTimeout" , "1" );

        OracleDataSource ods = new OracleDataSource();
        ods.setConnectionProperties(prop);
        ods.setURL("jdbc:oracle:thin:@192.168.56.113:1521:orcl");
        Connection conn = ods.getConnection();

//        System.setProperty("oracle.jdbc.ReadTimeout", "1");
//        Class.forName("oracle.jdbc.OracleDriver");
//        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.56.113:1521:orcl", "scott", "tiger");

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
