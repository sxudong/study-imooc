package test5;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/*
 * 测试打印执行的主线程名字
 * 通过 DBUtil 获取连接，并执行sql
 */

public class JDBCDemo3 {
	public static void main(String[] args) {
		try{
			Thread t = Thread.currentThread();
			System.out.println("执行main方法的线程是："+t);
			System.out.println("执行main方法的线程是："+t.getName());
			
			Connection conn = DBUtil.getConnection();
			System.out.println("数据库存已连接");
			
			Statement state = conn.createStatement();
			String sql = "SELECT * FROM emp";
			
			
			//执行Sql，得到结果集
			ResultSet rs = state.executeQuery(sql);
			
			while(rs.next()) {
				int empno = rs.getInt("empno");
				String ename = rs.getString("ename");
				int sal = rs.getInt("sal");
				int deptno = rs.getInt("deptno");
				System.out.println(empno+","+ename+","+sal+","+deptno);
			}
			
			/*
			 * 结果集使用完毕后就应当关闭，释放资源，
			 * 但是若Statement关闭了，那么rs也会自动关闭。
			 */
			rs.close();
			
			/*
			 * 当不再通过Satement执行其它sql时，我们应当及时关闭Statement
			 * 以释放JDBC与数据库的资源占用。
			 */
			state.close();
			
			//使用后关闭连接
			DBUtil.closeConnection(conn);		
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
/* Output:
执行main方法的线程是：Thread[main,5,main]
执行main方法的线程是：main
执行DBUtil.getConnection方法的线程是：main
数据库存已连接
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
执行closeConnection方法的线程是：main
 */