package design.pattern.behavioral.memento.example;

import java.util.Stack;

/**
 * 备忘录管理类
 * 使用了一个「栈」结构来管理,每次保存数据不就是入栈嘛，撤销肯定是恢复到最近
 * 一次的数据，那不就是出栈嘛，因此「栈」结构是非常适合的（这里不考虑反撤销）。
 */
public class Caretaker {
	Stack<Memento> stack = new Stack<>();

	public void save(Memento memento) {
		stack.push(memento);
	}

	public Memento restore(){
		if (stack.size() > 0) {
			return stack.pop();
		}
		throw new UnsupportedOperationException("无法撤销...");
	}
}
