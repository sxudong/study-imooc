package design.pattern.behavioral.memento.section8;

import java.util.HashMap;

/**
 * 备忘录管理员 —— 使用 HashMap 来存储备忘录
 *
 * 注意 内存溢出问题，该备份一旦产生就装入内存，没有任何销毁的意向，这是非常危
 * 险的。因此，在系统设计时，要严格限定备忘录的创建，建议增加 Map 的上限，否则系统很
 * 容易产生内存溢出情况。
 */
public class Caretaker {
	//容纳备忘录的容器
	private HashMap<String,Memento> memMap = new HashMap<String,Memento>();

	public Memento getMemento(String idx) {
		return memMap.get(idx);
	}

	public void setMemento(String idx, Memento memento) {
		this.memMap.put(idx, memento);
	}
	
}
