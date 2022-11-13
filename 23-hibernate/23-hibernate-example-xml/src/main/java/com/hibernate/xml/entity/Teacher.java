package com.hibernate.xml.entity;

import java.io.Serializable;
import java.util.Set;

/**
 * 老师：与学生是多对多的关系。
 * 
 * @author sean
 * 
 */
public class Teacher implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Integer id;

	private String teacherName;

	private Set<Student> students;

	public Teacher() {
	}

	public Teacher(Integer id, String teacherName, Set<Student> students) {
		super();
		this.id = id;
		this.teacherName = teacherName;
		this.students = students;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 获取老师姓名
	 * 
	 * @return
	 */
	public String getTeacherName() {
		return teacherName;
	}

	/**
	 * 设置老师姓名
	 * 
	 * @param teacherName
	 */
	public void setTeacherName(String teacherName) {
		this.teacherName = teacherName;
	}

	/**
	 * 获取老师的学生
	 * 
	 * @return
	 */
	public Set<Student> getStudents() {
		return students;
	}

	/**
	 * 设置老师的学生
	 * 
	 * @param students
	 */
	public void setStudents(Set<Student> students) {
		this.students = students;
	}

}
