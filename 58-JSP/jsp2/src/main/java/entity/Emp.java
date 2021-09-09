package entity;

import java.io.Serializable;
/*
 * 建议：
 * 1.尽量使用封装类型，因为它比基本类型多了null。
 * 2.使用java.sql包下的日期，因为JDBC支持这样的日期类型。
 * 基本类型只能按值传递，而每个基本类型对应的封装类是按引用传递的。
 */
public class Emp implements Serializable{
	private Integer empno;
	private String ename;
	private String job;
	private Double sal;
	
	public Integer getEmpno() {
		return empno;
	}
	public void setEmpno(Integer empno) {
		this.empno = empno;
	}
	public String getEname() {
		return ename;
	}
	public void setEname(String ename) {
		this.ename = ename;
	}
	public String getJob() {
		return job;
	}
	public void setJob(String job) {
		this.job = job;
	}
	public Double getSal() {
		return sal;
	}
	public void setSal(Double sal) {
		this.sal = sal;
	}
	
}
