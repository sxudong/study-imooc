package com.learn.pojo;
 
public class MyBean {
	private int age;
	private String name;
 
	public MyBean(int age, String name) {
		this.age = age;
		this.name = name;
	}
 
	public int getAge() {
		return age;
	}
 
	public void setAge(int age) {
		this.age = age;
	}
 
	public String getName() {
		return name;
	}
 
	public void setName(String name) {
		this.name = name;
	}
 
	@Override
	public String toString() {
		return "MyBean{" +
				"age=" + age +
				", name='" + name + '\'' +
				'}';
	}
}