package test6;

import java.io.InputStream;
import java.util.Properties;
import java.sql.Connection;
import java.sql.DriverManager;

/*
 * 使用 ThreadLocal 管理不同线程所获取的连接
 */
public class DBUtil {
	//连接数据的路径、用户名、密码
	private static String url;
	private static String user;
	private static String pwd;
	
	//ThreadLocal内部就是维护着一个Map，Map需要有Key和Value,
	//Key是Thread,ThreadLocal要求传一个泛型。
	//private static Map<Thread, Connection> map  
			                      //= new HashMap<Thread,Connection>();
	//ThreadLocal用于管理不同线程所获取的连接 
	private static ThreadLocal<Connection> tl = new ThreadLocal<Connection>();
	/*
	 * 静态块
	 * 静态块在类被虚拟机加载的时候会首先
	 * 执行静态块，加载一次,以后就不再加载。
	 */
	static {
		try{
			Thread t = Thread.currentThread();
			System.out.println("执行DBUtil.getConnection" + "方法的线程是："+t.getName());
		   //读取配置文件
			Properties prop = new Properties();
			/*
			 * 这种写法是将来更加推荐的相对路径写法
			 */
			InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("config.properties");
			//加载
			prop.load(is);
			
			//关闭流
			is.close();
			
			//获取驱动、地址、用户名、密码
			String driver = prop.getProperty("driver").trim();
			url = prop.getProperty("url").trim();
			user = prop.getProperty("user").trim();
			pwd = prop.getProperty("pwd").trim();
			//注册驱动
			Class.forName(driver);
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	/*
	 * 获取一个连接
	 * @return
	 */
	public static Connection getConnection() throws Exception{
		try{
			/*
			 * 通过DriverManager创建一个数据库的连接并返回
			 */
			Connection conn = DriverManager
					              .getConnection(url,user,pwd);
			/*
			 * ThreadLocal的set方法会将当前线程作为key，
			 * 并将给定的值作为value存入内部的map中保存。
			 */
			tl.set(conn);
			return conn;
		}catch(Exception e) {
			e.printStackTrace();
			//通知调用者，创建连接出错
			throw e;
		}
	}
	
	/**
	 * 关闭给定的连接
	 * @param conn
	 */
	public static void closeConnection(){
		try{
			Thread t = Thread.currentThread();
			System.out.println("执行closeConnection方法的线程是："
			                                +t.getName());
			Connection conn = tl.get();
			if(conn != null) {
				conn.close();
				tl.remove();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}