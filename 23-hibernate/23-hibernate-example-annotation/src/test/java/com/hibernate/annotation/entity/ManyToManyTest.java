package com.hibernate.annotation.entity;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import junit.framework.Assert;

import org.hibernate.Query;

import com.hibernate.annotation.BaseTest;

public class ManyToManyTest extends BaseTest {

	private String[] teacherNames = { "teacher1", "teacher2" };
	private String[] studentNames = { "student1", "student2", "student3" };

	/**
	 * test add
	 */
	public void testAdd() {
		logger.debug("test add");
		saveTeacherAndStudent();
	}

	/**
	 * test update
	 */
	@SuppressWarnings("unchecked")
	public void testUpdate() {

		logger.debug("test update");

		// 准备数据
		saveTeacherAndStudent();
		tx.commit();
		// 清楚session缓存，观察懒加载
		session.clear();

		// 级联更新
		tx = session.beginTransaction();

		List<Teacher> teachers = session
				.createQuery(
						"from Teacher where teacherName like ? order by teacherName asc")
				.setString(0, "teacher%").list();
		Teacher teacher1 = teachers.get(0);
		Teacher teacher2 = teachers.get(1);
		teacher1.setTeacherName(teacherNames[0] + "1");
		teacher2.setTeacherName(teacherNames[1] + "1");

		int i = 1;
		Set<Student> students1 = teacher1.getStudents();
		Set<Student> students2 = teacher2.getStudents();
		for (Iterator<Student> iterator = students1.iterator(); iterator
				.hasNext();) {
			Student student = iterator.next();
			student.setStudentName(student.getStudentName() + i);
			i++;
		}
		for (Iterator<Student> iterator = students2.iterator(); iterator
				.hasNext();) {
			Student student = iterator.next();
			student.setStudentName(student.getStudentName() + i);
			i++;
		}

		session.update(teacher1);
		session.update(teacher2);
		session.flush();
		List<Student> students = session
				.createQuery(
						"select s from Teacher t join t.students s where t.teacherName=? order by s.studentName asc")
				.setString(0, teacherNames[0] + "1").list();
		Student student1 = students.get(0);
		Student student2 = students.get(1);

		Assert.assertEquals(teacherNames[0] + "1", teacher1.getTeacherName());
		Assert.assertEquals(teacherNames[1] + "1", teacher2.getTeacherName());
		Assert.assertEquals("student113", student1.getStudentName());
		Assert.assertEquals("student224", student2.getStudentName());

		List<Object[]> list = session.createSQLQuery(
				"select * from teacher_student").list();
		for (Object[] teacherStudent : list) {
			System.out.println(teacherStudent[0] + "\t" + teacherStudent[1]);
		}
	}

	/**
	 * test delete
	 */
	@SuppressWarnings("unchecked")
	public void testDelete() {

		logger.debug("test delete");
		// 准备数据
		saveTeacherAndStudent();
		tx.commit();
		session.clear();

		// 级联删除
		tx = session.beginTransaction();
		// 这样执行语句无法级联删除。
		// Query query = session.createQuery("delete from Teacher");
		// query.executeUpdate();
		
		// 只有通过delete方法才能实现级联操作。
		List<Teacher> teachers = session.createQuery("from Teacher").list();
		for (Teacher teacher : teachers) {
			session.delete(teacher);
		}
	}

	@Override
	protected void clearData() {
		tx = session.beginTransaction();
		Query query = session.createSQLQuery("delete from teacher_student");
		query.executeUpdate();
		query = session.createQuery("delete from Teacher");
		query.executeUpdate();
		query = session.createQuery("delete from Student");
		query.executeUpdate();
		tx.commit();
	}

	private void saveTeacherAndStudent() {
		
		Set<Teacher> teachers = new HashSet<Teacher>();
		Set<Teacher> teachers2 = new HashSet<Teacher>();
		Teacher teacher1 = new Teacher();
		teacher1.setTeacherName(teacherNames[0]);
		Teacher teacher2 = new Teacher();
		teacher2.setTeacherName(teacherNames[1]);
		teachers.add(teacher1);
		teachers.add(teacher2);
		teachers2.add(teacher2);

		Set<Student> students = new HashSet<Student>();
		Student student1 = new Student();
		student1.setStudentName(studentNames[0]);
		Student student2 = new Student();
		student2.setStudentName(studentNames[1]);
		Student student3 = new Student();
		student3.setStudentName(studentNames[2]);
		students.add(student1);
		students.add(student2);
		student1.setTeachers(teachers);
		student2.setTeachers(teachers);
		student3.setTeachers(teachers2);

		teacher1.setStudents(students);
		Set<Student> students2 = new HashSet<Student>(students);
		students2.add(student3);
		teacher2.setStudents(students2);
		session.save(teacher1);
		session.save(teacher2);
	}
}
