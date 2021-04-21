package design.pattern.structural.composite.section5;

import java.util.ArrayList;

/**
 * 21.4.2 透明的组合模式
 *
 * 透明模式则是将组合使用的方法全部放到了抽象组件中，这样不管是树枝对象还是树叶对象，
 * 都具有相同的结构，这种方式需要客户端判断子类类型，操作不当容易导致异常。
 */
public abstract class Component {
	
	//个体和整体都具有的共享
	public void doSomething(){
		//编写业务逻辑
	}	
	
	//增加一个叶子构件或树枝构件
	public abstract void add(Component component);
	
	//删除一个叶子构件或树枝构件
	public abstract void remove(Component component);
	
	//获得分支下的所有叶子构件和树枝构件
	public abstract ArrayList<Component> getChildren();
}
