package design.pattern.behavioral.memento.section5;


/**
 * 融合“备忘录”的发起人角色
 */
public class Originator implements Cloneable {
	
	//内部状态
	private String state = "";
	
	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	//创建一个备忘录
	public Originator createMemento(){
		return this.clone();
	}
	
	//恢复一个备忘录
	public void restoreMemento(Originator _originator){
		this.setState(_originator.getState());
	}
	
	//克隆当前对象
	@Override
	protected Originator clone(){
		
		try {
			return (Originator)super.clone();
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
		}
		return null;
	}
}
