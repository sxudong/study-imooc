package test1;

import java.sql.*;

public class Jdbctest {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        String url="jdbc:mysql://localhost:3306/orcl?serverTimezone=UTC";
        String user="root";
        String password="root";
        String driver="com.mysql.cj.jdbc.Driver"; //旧版驱动 com.mysql.jdbc.Driver

        Class.forName(driver);//为什么要这么做呢？可以利用Try语句判断驱动是否加载。在这里我是直接抛出，建议大家这么做。

        Connection con=DriverManager.getConnection(url,user,password);//连接对象

        if (!con.isClosed()){
            //System.out.println("数据库连接成功！");
            String sqlstr="select * from emp";
            Statement stmt= con.createStatement();
            ResultSet re=stmt.executeQuery(sqlstr);
            while (re.next()){
                System.out.println(re.getInt("empno")+"->"+re.getString("ename"));
            }
        }
        con.close();
    }
}
/* Output:
7369->SMITH
7499->ALLEN
7521->WARD
7566->JONES
7654->MARTIN
7698->BLAKE
7782->CLARK
7788->SCOTT
7839->KING
7844->TURNER
7876->ADAMS
7900->JAMES
7902->FORD
7934->MILLER
 */