package design.pattern.behavioral.memento.section7;

/**
 * 备忘录管理员
 */
public class Caretaker {
	
	//备忘录对象
	private Memento memento;

	public Memento getMemento() {
		return memento;
	}

	public void setMemento(Memento memento) {
		this.memento = memento;
	}
	
}
