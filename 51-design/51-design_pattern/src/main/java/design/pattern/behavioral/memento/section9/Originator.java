package design.pattern.behavioral.memento.section9;

/**
 * 发起人角色
 *
 * 一个备份的数据是完全、绝对不能修改的，它保证数据的洁净，避免数据污染。
 * 建立一个空接口 IMemento —— 什么方法属性都没有的接口，然后在发起人
 * Originator 类中建立一个内置类（也叫做类中类） Memento 实现 IMemento 接口，
 * 同时也实现自己的业务逻辑。
 */
public class Originator {
	
	//内部状态
	private String state = "";
	
	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	//创建一个备忘录
	public IMemento createMemento(){
		return new Memento(this.state);
	}
	
	//恢复一个备忘录
	public void restoreMemento(IMemento _memento){
		this.setState(((Memento)_memento).getState());
	}
	
	//内置类
	private class Memento implements IMemento{
		
		//发起人的内部状态
		private String state = "";
		
		//构造函数传递参数
		private Memento(String _state){
			this.state = _state;
		}
		
		private String getState() {
			return state;
		}

		private void setState(String state) {
			this.state = state;
		}
		
	}
}
