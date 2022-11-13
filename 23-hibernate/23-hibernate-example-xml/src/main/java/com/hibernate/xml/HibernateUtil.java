package com.hibernate.xml;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.connection.ConnectionProvider;
import org.hibernate.engine.SessionFactoryImplementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * 此类负责创建 SessionFactory，此类，一个应用程序只有一个，且是线程安全的
 * SessionFactory 相当于数据库连接池,  Session 相当于 connection
 */
public class HibernateUtil {

	// 声明会话工厂（session(用完后即死亡),connection）
	private static final SessionFactory SESSION_FACTORY = buildSessionFactory();

	private static SessionFactory buildSessionFactory() {

		// 声明读取配置文件的类，此类在实例化时默认即读取
		// configure() 默认会先去读取 classpath 下的 hibernate.properties,然后读取 hibernate.cfg.xml 文件,后者会覆盖前者
		return new Configuration().configure().buildSessionFactory(); //创建会话工厂
	}

	//返回会话的工厂
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
