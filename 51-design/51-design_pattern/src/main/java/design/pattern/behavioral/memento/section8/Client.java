package design.pattern.behavioral.memento.section8;

/**
 * 备忘录管理员 —— 使用 HashMap 来存储备忘录
 *
 * 注意 内存溢出问题，该备份一旦产生就装入内存，没有任何销毁的意向，这是非常危
 * 险的。因此，在系统设计时，要严格限定备忘录的创建，建议增加Map的上限，否则系统很
 * 容易产生内存溢出情况。
 */
public class Client {
	
	public static void main(String[] args) {
		//定义出发起人
		Originator originator = new Originator();
		//定义出备忘录管理员
		Caretaker caretaker = new Caretaker();
		//创建两个备忘录
		caretaker.setMemento("001",originator.createMemento());
		caretaker.setMemento("002",originator.createMemento());
		//恢复一个指定标记的备忘录
		originator.restoreMemento(caretaker.getMemento("001"));
	}
}
