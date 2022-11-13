package com.hibernate.xml.entity;

import java.io.Serializable;
import java.util.Set;

public class Student implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Integer id;

	private String studentName;

	private Set<Teacher> teachers;

	public Student() {
	}

	public Student(Integer id, String studentName, Set<Teacher> teachers) {
		super();
		this.id = id;
		this.studentName = studentName;
		this.teachers = teachers;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 获取学生姓名
	 * 
	 * @return
	 */
	public String getStudentName() {
		return studentName;
	}

	/**
	 * 设置学生姓名
	 * 
	 * @param studentName
	 */
	public void setStudentName(String studentName) {
		this.studentName = studentName;
	}

	/**
	 * 获取学生的老师
	 * 
	 * @return
	 */
	public Set<Teacher> getTeachers() {
		return teachers;
	}

	/**
	 * 设置学生的老师
	 * 
	 * @param teachers
	 */
	public void setTeachers(Set<Teacher> teachers) {
		this.teachers = teachers;
	}

}
