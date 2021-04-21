package design.pattern.behavioral.visitor.example2;

import design.pattern.behavioral.visitor.example2.visitor.Visitor;
import lombok.Getter;

/**
 * 核心档案类
 */
@Getter
public class Archive implements Visitable {
	private String code;//档案号
	private String name;//姓名
	private String sex;//性别
	private String position;//位置
	private String inDate;//转入时间
	private String outDate;//转出时间
	private Boolean imaged;//是否影像化

	public Archive(String code, String name, String sex, String position, String inDate, String outDate, Boolean imaged) {
		this.code = code;
		this.name = name;
		this.sex = sex;
		this.position = position;
		this.inDate = inDate;
		this.outDate = outDate;
		this.imaged = imaged;
	}

	@Override
	public void accept(Visitor visitor) {
		visitor.visit(this);
	}
}
