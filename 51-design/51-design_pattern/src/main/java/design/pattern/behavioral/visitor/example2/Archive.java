package design.pattern.behavioral.visitor.example2;

import design.pattern.behavioral.visitor.example2.visitor.Visitor;

/**
 * 核心档案类
 */
//@Getter
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

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getInDate() {
		return inDate;
	}

	public void setInDate(String inDate) {
		this.inDate = inDate;
	}

	public String getOutDate() {
		return outDate;
	}

	public void setOutDate(String outDate) {
		this.outDate = outDate;
	}

	public Boolean getImaged() {
		return imaged;
	}

	public void setImaged(Boolean imaged) {
		this.imaged = imaged;
	}
}
