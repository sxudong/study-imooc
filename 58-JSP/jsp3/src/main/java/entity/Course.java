package entity;

import java.io.Serializable;

public class Course implements Serializable {
	//对象的属性
	private Integer courseId;
	private String courseName;
	private Integer days;

	//1.和get/set对应的属性叫Bean属性
	//2.通过get/set反应同来的我们以为的属性
	//3.去掉get并将首字母小写的单词就是Bean属性
	//Bean属性通常都和对象属性一致，也可以修改为不一致

	public Integer getId() {
		return courseId;
	}
	public void setId(Integer courseId) {
		this.courseId = courseId;
	}
	public String getCourseName() {
		return courseName;
	}
	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}
	public Integer getDays() {
		return days;
	}
	public void setDays(Integer days) {
		this.days = days;
	}

}