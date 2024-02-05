package testOracleConn;

import java.sql.Connection;
import java.sql.DriverManager;


public class DBUtil {

	public static Connection getConnection() throws Exception{
		try{
			/*
			 * 通过DriverManager创建一个数据库的连接并返回
			 */
			String readTimeout = "1"; // ms
			System.setProperty("oracle.jdbc.ReadTimeout", readTimeout);
			Class.forName("oracle.jdbc.OracleDriver");
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.56.113:1521:orcl", "scott", "tiger");
		    return conn;
		}catch(Exception e) {
			e.printStackTrace();
			//通知调用者，创建连接出错
			throw e;
		}
	}

	public static void closeConnection(Connection conn){
		try{
			if(conn != null) {
				conn.close();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}