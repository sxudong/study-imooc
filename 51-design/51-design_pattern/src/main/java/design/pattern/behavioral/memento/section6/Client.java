package design.pattern.behavioral.memento.section6;

/**
 *
 */
public class Client {
	
	public static void main(String[] args) {
		//定义发起人
		Originator originator = new Originator();
		//建立初始状态
		originator.setState("初始状态...");
		System.out.println("初始状态是："+originator.getState());
		//建立备份
		originator.createMemento();
		//修改状态
		originator.setState("修改后的状态...");
		System.out.println("修改后状态是："+originator.getState());
		//恢复原有状态
		originator.restoreMemento();
		System.out.println("恢复后状态是："+originator.getState());
	}
}
