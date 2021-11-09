package com.SpringSourceAnalysis.ch09.mybatis;

/**
 * 《Spring源码深度解析》第9章 整合Mybatis P231
 */
public interface UserMapper {
	public void insertUser(User user);
	public User getUser(Integer id);
}
