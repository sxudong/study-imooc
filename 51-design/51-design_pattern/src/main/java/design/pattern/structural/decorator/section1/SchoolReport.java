package design.pattern.structural.decorator.section1;

/**
 * 《设计模式之禅》
 * 成绩单的抽象类
 */
public abstract class SchoolReport {

	//成绩单的主要展示的就是你的成绩情况
	public abstract void report();
	
	//成绩单要家长签字，这个是最要命的
	public abstract void sign(String name);
}
