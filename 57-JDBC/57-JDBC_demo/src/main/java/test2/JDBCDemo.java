package test2;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

/**
 * 测试使用JDBC连接Oracle数据库
 * @author 
 *
 */
public class JDBCDemo {
	public static void main(String[] args) {
		try{
		//加载驱动
		/*当出现了：
		 * java.lang.ClassNotFoundException:
		 * oracle.jdbc.driver.OracleDriver
		 * com.mysql.jdbc.Driver
		 * com.mysql.cj.jdbc.Driver
		 * 异常时，说明数据库存的驱动jar包没有导入到项目中。
		 * 若导入了jar包还报这个错误，大部分原因是书写的驱动有错误
		 */
		Class.forName("com.mysql.cj.jdbc.Driver");
		/*
		 * 第二步：
		 * 通过DriverManager获取数据库连接
		 * 
		 * 注意：
		 * 导入的包都在java.sql.*
		 * 
		 * DriverManager连接ORACLE时的路径格式：
		 * jdbc:oracle:thin:@<host>:<port>:<数据库名>
		 * 
		 * MySQL的路径：端口号通常是3306
		 * jdbc:mysql://<host>:<port>/<数据库名>
		 */
		Connection conn = DriverManager.getConnection
		("jdbc:mysql://localhost:3306/orcl?serverTimezone=UTC","root","root");
		
		/*
		 * 通过Connection创建对象Statement用来执行SQL语句
		 */
		Statement state = conn.createStatement();
		
		/*
		 * 通过Statement执行查询语句
		 * 查询emp表中的信息
		 * SELECT empno,ename,sal,deptno FROM emp
		 */
		String sql = "SELECT empno,ename,sal,deptno FROM emp";
		
		//输出sql，用于检查拼写是否有错误
		System.out.println(sql);
		
		/*
		 * 使用executeQuery来执行DQL语句，并且查询后会得到一个查询结果集
		 * getInt(),getString(),getDate(),getDouble()
		 */
		ResultSet rs = state.executeQuery(sql);
		
		/*
		 * 需要注意的是，ResultSet表示的是查询结果集，但实际上查询的结果集
		 * 在ORACLE数据库服务器上，并没有全部保存在本地，所以我们通过ResultSet
		 * 的next方法获取下一条记录时，ResultSet会发送请至服务端获取数据，
		 * 若连接已经关闭，那么会抛异常。
		 */
		
		while(rs.next()) {
			int empno = rs.getInt("empno");
			String ename = rs.getString("ename");
			int sal = rs.getInt("sal");
			int deptno = rs.getInt("deptno");
			System.out.println(empno+","+ename+","+sal+","+deptno);
		}
		//关闭连接
		conn.close();

		}catch(Exception e) {
			e.printStackTrace();
		}
	}
} /* Output:
SELECT empno,ename,sal,deptno FROM emp
7369,SMITH,800,20
7499,ALLEN,1600,30
7521,WARD,1250,30
7566,JONES,2975,20
7654,MARTIN,1250,30
7698,BLAKE,2850,30
7782,CLARK,2450,10
7788,SCOTT,3000,20
7839,KING,5000,10
7844,TURNER,1500,30
7876,ADAMS,1100,20
7900,JAMES,950,30
7902,FORD,3000,20
7934,MILLER,1300,10
*/