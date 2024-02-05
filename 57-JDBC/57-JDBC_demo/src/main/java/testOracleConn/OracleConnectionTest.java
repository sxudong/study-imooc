package testOracleConn;

import java.sql.*;
import java.util.Properties;

/**
 * jdbc socketTimeout 的设置
 * https://blog.csdn.net/weixin_34281477/article/details/88910721
 */
public class OracleConnectionTest {
	public static void main(String[] args) throws SQLException, ClassNotFoundException {
/*
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Properties props = new Properties() ;
		props.put( "user" , "scott") ;
		props.put( "password" , "tiger") ;
		props.put( "oracle.net.CONNECT_TIMEOUT" , "10000000") ;
		props.put( "oracle.jdbc.ReadTimeout" , "2000" ) ;

		Connection conn = DriverManager.getConnection( "jdbc:oracle:thin:@192.168.56.113:1521:orcl" , props);
*/

		String readTimeout = "10000"; // ms
		System.setProperty("oracle.jdbc.ReadTimeout", readTimeout);
		Class.forName("oracle.jdbc.OracleDriver");
		Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.56.113:1521:orcl", "scott", "tiger");

		Statement state = conn.createStatement();
		String sql = "SELECT * FROM emp";

		ResultSet rs = state.executeQuery(sql);

		while(rs.next()) {
			int empno = rs.getInt("empno");
			String ename = rs.getString("ename");
			int sal = rs.getInt("sal");
			int deptno = rs.getInt("deptno");
			System.out.println(empno+","+ename+","+sal+","+deptno);
		}

		rs.close();
	}
}
