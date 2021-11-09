package com.SpringSourceAnalysis.mybatis;

import com.SpringSourceAnalysis.ch09.mybatis.MyBatisUtil;
import com.SpringSourceAnalysis.ch09.mybatis.UserMapper;
import com.SpringSourceAnalysis.ch09.mybatis.User;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;


/**
 * 《Spring源码深度解析》第9章 整合Mybatis P231
 */
public class MyBatisTests {
	static SqlSessionFactory sqlSessionFactory;
	
	static {
		sqlSessionFactory = MyBatisUtil.getSqlSessionFactory();
	}
	
	
	public void testAdd() {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		try {
			UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
			User user = new User("min", 18);
			user.setSex("Male");
			userMapper.insertUser(user);
			sqlSession.commit();
		}finally {
			sqlSession.close();
		}
	}

	/**
	 * 使用的是 mybatis jar包
	 */
	@Test
	public void getUser() {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		try {
			UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
			User user = userMapper.getUser(1);
			System.out.println("name:"+user.getName()+",age:"+user.getAge());
		} finally {
			sqlSession.close();
		}
	}/* Output:
	name:张三,age:20
	*///~
}
