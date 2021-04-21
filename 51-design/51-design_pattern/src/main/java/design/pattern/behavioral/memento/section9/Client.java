package design.pattern.behavioral.memento.section9;

/**
 * 一个备份的数据是完全、绝对不能修改的，它保证数据的洁净，避免数据污染。
 * 建立一个空接口 IMemento —— 什么方法属性都没有的接口，然后在发起人
 * Originator 类中建立一个内置类（也叫做类中类） Memento 实现 IMemento 接口，
 * 同时也实现自己的业务逻辑。
 */
public class Client {
	
	public static void main(String[] args) {
		//定义出发起人
		Originator originator = new Originator();
		//定义出备忘录管理员
		Caretaker caretaker = new Caretaker();
		//创建一个备忘录
		caretaker.setMemento(originator.createMemento());
		//恢复一个备忘录
		originator.restoreMemento(caretaker.getMemento());
	}
}
