package com.myimooc.spring.simple.aop.api.introduction;

/**
 * 视频：6-1 Spring AOP API的Pointcut、advice概念及应用
 */
public interface Lockable {
	void lock();
	void unlock();
	boolean locked();
}