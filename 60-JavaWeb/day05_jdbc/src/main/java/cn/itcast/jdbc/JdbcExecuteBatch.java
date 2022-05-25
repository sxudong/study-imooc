package cn.itcast.jdbc;


/**
 * executeBatch()详解
 *
 * JDBC 提供了数据库 batch 处理的能力，在数据大批量操作(新增、删除等)的情况下可以大幅度提升系统的性能。
 *
 *   // 关闭自动执行
 *   con.setAutoCommit(false);
 *
 *   Statement stmt = con.createStatement();
 *   stmt.addBatch(“INSERT INTO employees VALUES (1000, ‘Joe Jones’)”);
 *   stmt.addBatch(“INSERT INTO departments VALUES (260, ‘Shoe’)”);
 *   stmt.addBatch(“INSERT INTO emp_dept VALUES (1000, 260)”);
 *
 *   // 提交一批要执行的更新命令
 *   int[] updateCounts = stmt.executeBatch();
 */
public class JdbcExecuteBatch {

    /*
      1，jdbc批处理语句的方法：
        ■  addBatch(); 添加需要批量处理的SQL语句或者参数；
        ■  executeBatch(); 执行批量处理语句；
     */
}
