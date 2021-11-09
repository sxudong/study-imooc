package com.SpringSourceAnalysis.ch09.mybatis;

/**
 * 《Spring源码深度解析》第9章 整合Mybatis
 */
public class User {
	private Integer id;
	private String name;
	private Integer age;
	private String sex;
	
	public User(String name, Integer age) {
		super();
		this.name = name;
		this.age = age;
	}
	
	public User() {
		super();
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

}
