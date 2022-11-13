package com.hibernate.annotation;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import junit.framework.TestCase;

public abstract class BaseTest extends TestCase {
	
	protected Logger logger = LoggerFactory.getLogger(getClass());

	private SessionFactory sessionFactory = HibernateTestUtil
			.getSessionFactory();
	protected Session session;
	protected Transaction tx;

	protected void setUp() throws Exception {
		super.setUp();
		session = sessionFactory.openSession();
		clearData();
		tx = session.beginTransaction();
	}

	protected void tearDown() throws Exception {
		tx.commit();
		session.close();
		super.tearDown();
	}
	
	public void test_(){
		logger.debug("test_");
	}
	
	protected abstract void clearData();

}
