package test7;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

import org.apache.commons.dbcp.BasicDataSource;



/**
 * 使用 Apache DBCP 连接池技术管理数据库存连接
 * @author Administrator
 *
 */
public class DBUtil {
	//数据库连接池
	private static BasicDataSource ds;
	//为不同线程管理连接
	private static ThreadLocal<Connection> tl;
	
	//不需要实例的，全部都是静态方法，所以不需在构造方法里初始化
	static {
		try {
			Properties prop = new Properties();
			InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("config.properties");
			prop.load(is);
			is.close();
			
			//初始化连接池
			ds = new BasicDataSource();
			//设置驱动(Class.forName())
			ds.setDriverClassName(prop.getProperty("driver"));
			//设置url、数据库用户名、密码
			ds.setUrl(prop.getProperty("url"));
			ds.setUsername(prop.getProperty("user"));
			ds.setPassword(prop.getProperty("pwd"));
			
			//初始连接数量 
			ds.setInitialSize(Integer.parseInt(
					prop.getProperty("initsize")));
			//连接池允许的最大连接数
			ds.setMaxActive(Integer.parseInt(
					prop.getProperty("maxactive")));
			//设置最大等待时间
			ds.setMaxWait(Integer.parseInt(
					prop.getProperty("maxwait")));
			//设置最小空闲数
			ds.setMinIdle(Integer.parseInt(
					prop.getProperty("minidle")));
			//设置最大空闲数
			ds.setMaxIdle(Integer.parseInt(
					prop.getProperty("maxidle")));
			//初始化线程本地
			tl = new ThreadLocal<Connection>();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 获取数据库连接
	 * @return
	 * @throws SQLException 
	 */
	public static Connection getConnection() throws SQLException{
		/*
		 * 通过连接池获取一个空闲连接
		 */
		Connection conn = ds.getConnection();
		tl.set(conn);
		return conn;
	}
    /**
     * 关闭数据库连接
     */
	public static void closeConnection(){
		try{
		Connection conn = tl.get();
		if(conn != null) {
			/*
			 * 通过连接池获取的Connection的close()方法
			 * 实际上并没有将连接闭关，而将该链接归还。
			 */
			conn.close();
			tl.remove();
		}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
