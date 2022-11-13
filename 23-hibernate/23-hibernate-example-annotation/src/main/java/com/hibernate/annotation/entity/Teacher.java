package com.hibernate.annotation.entity;

import java.io.Serializable;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;

/**
 * 老师：与学生是多对多的关系。
 * 
 * @author sean
 * 
 */
@Entity
@Table(name = "teacher", uniqueConstraints = { @UniqueConstraint(columnNames = "teacher_name") })
public class Teacher implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "teacher_name", nullable = false, length = 20)
	private String teacherName;

	/**
	 * 定义mappedBy的对方是关系的拥有方，维护关系。
	 */
	@ManyToMany(mappedBy = "teachers")
	@OrderBy("studentName asc")
	@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE })
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
