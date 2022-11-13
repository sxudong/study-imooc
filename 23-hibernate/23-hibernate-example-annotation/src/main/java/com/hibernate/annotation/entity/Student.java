package com.hibernate.annotation.entity;

import java.io.Serializable;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * 学生：和老师是多对多的关系
 * 
 * @author sean
 * 
 */
@Entity
@Table(name = "student", uniqueConstraints = { @UniqueConstraint(columnNames = { "student_name" }) })
public class Student implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "student_name", nullable = false, length = 20)
	private String studentName;
	
	/**
	 * mappedBy定义在被拥有方：老师拥有学生。
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	@OrderBy("teacherName asc")
	@JoinTable(name = "teacher_student", joinColumns = @JoinColumn(name = "student_id", nullable = false, updatable = false), inverseJoinColumns = @JoinColumn(name = "teacher_id", nullable = false, updatable = false))
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
