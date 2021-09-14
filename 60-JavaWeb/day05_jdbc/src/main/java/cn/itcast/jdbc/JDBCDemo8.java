package cn.itcast.jdbc;

import cn.itcast.domain.Emp;
import cn.itcast.util.JDBCUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * * 定义一个方法，查询emp表的数据将其封装为对象，然后装载集合，返回。
 */
public class JDBCDemo8 {

    public static void main(String[] args) {
        List<Emp> list = new JDBCDemo8().findAll2();
        System.out.println(list);
        System.out.println(list.size());
    }
    /**
     * 查询所有emp对象
     * @return
     */
    public List<Emp> findAll(){
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Emp> list = null;
        try {
            //1.注册驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            //2.获取连接
            conn = DriverManager.getConnection("jdbc:mysql:///db3?serverTimezone=UTC", "root", "root");
            //3.定义sql
            String sql = "select * from emp";
            //4.获取执行sql的对象
            stmt = conn.createStatement();
            //5.执行sql
            rs = stmt.executeQuery(sql);
            //6.遍历结果集，封装对象，装载集合
            Emp emp = null;
            list = new ArrayList<Emp>();
            while(rs.next()){
                //获取数据
                int id = rs.getInt("id");
                String ename = rs.getString("ename");
                int job_id = rs.getInt("job_id");
                int mgr = rs.getInt("mgr");
                Date joindate = rs.getDate("joindate");
                double salary = rs.getDouble("salary");
                double bonus = rs.getDouble("bonus");
                int dept_id = rs.getInt("dept_id");
                // 创建emp对象,并赋值
                emp = new Emp();
                emp.setId(id);
                emp.setEname(ename);
                emp.setJob_id(job_id);
                emp.setMgr(mgr);
                emp.setJoindate(joindate);
                emp.setSalary(salary);
                emp.setBonus(bonus);
                emp.setDept_id(dept_id);

                //装载集合
                list.add(emp);
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            if(rs != null){
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if(stmt != null){
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if(conn != null){
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return list;
    }


    /**
     * 演示JDBC工具类
     * @return
     */
    public List<Emp> findAll2(){
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Emp> list = null;
        try {
            //1.注册驱动
//            Class.forName("com.mysql.jdbc.Driver");
//            //2.获取连接
//            conn = DriverManager.getConnection("jdbc:mysql:///db3?serverTimezone=UTC", "root", "root");
            conn = JDBCUtils.getConnection();
            //3.定义sql
            String sql = "select * from emp";
            //4.获取执行sql的对象
            stmt = conn.createStatement();
            //5.执行sql
            rs = stmt.executeQuery(sql);
            //6.遍历结果集，封装对象，装载集合
            Emp emp = null;
            list = new ArrayList<Emp>();
            while(rs.next()){
                //获取数据
                int id = rs.getInt("id");
                String ename = rs.getString("ename");
                int job_id = rs.getInt("job_id");
                int mgr = rs.getInt("mgr");
                Date joindate = rs.getDate("joindate");
                double salary = rs.getDouble("salary");
                double bonus = rs.getDouble("bonus");
                int dept_id = rs.getInt("dept_id");
                // 创建emp对象,并赋值
                emp = new Emp();
                emp.setId(id);
                emp.setEname(ename);
                emp.setJob_id(job_id);
                emp.setMgr(mgr);
                emp.setJoindate(joindate);
                emp.setSalary(salary);
                emp.setBonus(bonus);
                emp.setDept_id(dept_id);

                //装载集合
                list.add(emp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            /*if(rs != null){
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if(stmt != null){
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if(conn != null){
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }*/

            JDBCUtils.close(rs,stmt,conn);
        }
        return list;
    }/* Output:
    [Emp{id=1001, ename='孙悟空', job_id=4, mgr=1004, joindate=2000-12-17, salary=8000.0, bonus=0.0, dept_id=20}, Emp{id=1002, ename='卢俊义', job_id=3, mgr=1006, joindate=2001-02-20, salary=16000.0, bonus=3000.0, dept_id=30}, Emp{id=1003, ename='林冲', job_id=3, mgr=1006, joindate=2001-02-22, salary=12500.0, bonus=5000.0, dept_id=30}, Emp{id=1004, ename='唐僧', job_id=2, mgr=1009, joindate=2001-04-02, salary=29750.0, bonus=0.0, dept_id=20}, Emp{id=1005, ename='李逵', job_id=4, mgr=1006, joindate=2001-09-28, salary=12500.0, bonus=14000.0, dept_id=30}, Emp{id=1006, ename='宋江', job_id=2, mgr=1009, joindate=2001-05-01, salary=28500.0, bonus=0.0, dept_id=30}, Emp{id=1007, ename='刘备', job_id=2, mgr=1009, joindate=2001-09-01, salary=24500.0, bonus=0.0, dept_id=10}, Emp{id=1008, ename='猪八戒', job_id=4, mgr=1004, joindate=2007-04-19, salary=30000.0, bonus=0.0, dept_id=20}, Emp{id=1009, ename='罗贯中', job_id=1, mgr=0, joindate=2001-11-17, salary=50000.0, bonus=0.0, dept_id=10}, Emp{id=1010, ename='吴用', job_id=3, mgr=1006, joindate=2001-09-08, salary=15000.0, bonus=0.0, dept_id=30}, Emp{id=1011, ename='沙僧', job_id=4, mgr=1004, joindate=2007-05-23, salary=11000.0, bonus=0.0, dept_id=20}, Emp{id=1012, ename='李逵', job_id=4, mgr=1006, joindate=2001-12-03, salary=9500.0, bonus=0.0, dept_id=30}, Emp{id=1013, ename='小白龙', job_id=4, mgr=1004, joindate=2001-12-03, salary=30000.0, bonus=0.0, dept_id=20}, Emp{id=1014, ename='关羽', job_id=4, mgr=1007, joindate=2002-01-23, salary=13000.0, bonus=0.0, dept_id=10}]
    14
    */
}
