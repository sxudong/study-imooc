package com.hibernate.xml.learning;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import junit.framework.Assert;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.jdbc.Work;

import com.hibernate.xml.BaseTest;
import com.hibernate.xml.entity.Stock;

/**
 * 查看SQL query flush会不会有效
 * 
 * @author sean
 * 
 */
public class SqlQueryFlushTest extends BaseTest {

	@Override
	protected void clearData() {
		tx = session.beginTransaction();
		Query query = session.createQuery("delete from Stock");
		query.executeUpdate();
		tx.commit();
	}

	public void testSqlQueryFlush() {
		SQLQuery sqlQuery = session
				.createSQLQuery("insert into stock(stock_name, stock_code) values(?, ?)");
		sqlQuery.setParameter(0, "张三");
		sqlQuery.setParameter(1, "123");
		// 是立即执行的 FIXME
		sqlQuery.executeUpdate();

		// 没用 FIXME
		// session.flush();

		sqlQuery.setParameter(0, "李四");
		sqlQuery.setParameter(1, "321");
		sqlQuery.executeUpdate();
	}

	/**
	 * 批量插入
	 */
	public void testBatchUpdate() {
		final String sql = "insert into stock(stock_name, stock_code) values(?, ?)";
		session.doWork(new Work() {

			@Override
			public void execute(Connection connection) throws SQLException {
				Assert.assertNotNull(connection);
				connection.setAutoCommit(false);

				PreparedStatement statement = connection.prepareStatement(sql);

				statement.setString(1, "张三");
				statement.setString(2, "123");
				statement.addBatch();
				statement.executeBatch();

				statement.setString(1, "李四");
				statement.setString(2, "321");
				statement.addBatch();
				statement.executeBatch();

				connection.commit();

				logger.info("Done!");
			}
		});

		Query query = session.createQuery("from Stock");
		@SuppressWarnings("unchecked")
		List<Stock> list = query.list();
		Assert.assertTrue(list.size() == 2);
	}

}
