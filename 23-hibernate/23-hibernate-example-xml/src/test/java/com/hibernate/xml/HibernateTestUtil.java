package com.hibernate.xml;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.connection.ConnectionProvider;
import org.hibernate.engine.SessionFactoryImplementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class HibernateTestUtil {

	private static final SessionFactory SESSION_FACTORY = buildSessionFactory();

	private static SessionFactory buildSessionFactory() {

		return new Configuration().configure("hibernate-test.cfg.xml").buildSessionFactory();
	}

	public static SessionFactory getSessionFactory() {
		return SESSION_FACTORY;
	}

	public static void shutdown() {
		SESSION_FACTORY.close();
	}

	public static Session getSession(){			//从工厂打开一个新的Session并返回
		return SESSION_FACTORY.openSession();
	}

//	public static void main(String[] args) throws SQLException {
//		ConnectionProvider connectionProvider = ((SessionFactoryImplementor) new Configuration().configure("hibernate-test.cfg.xml")).getConnectionProvider();
//		Connection conn = connectionProvider.getConnection();
//		PreparedStatement prep = conn.prepareStatement(sql);
//		prep.execute();
//		conn.commit();
//	}
}
