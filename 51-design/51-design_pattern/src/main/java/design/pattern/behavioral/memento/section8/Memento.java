package design.pattern.behavioral.memento.section8;

/**
 * 备忘录
 */
public class Memento {
	
	//发起人的内部状态
	private String state = "";
	
	//构造函数传递参数
	public Memento(String _state){
		this.state = _state;
	}
	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}
	
}
