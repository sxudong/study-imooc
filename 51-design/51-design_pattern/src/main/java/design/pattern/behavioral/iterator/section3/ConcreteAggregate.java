package design.pattern.behavioral.iterator.section3;

import java.util.Vector;

/**
 * 设计模式之禅——迭代器模式
 * 具体容器
 */
public class ConcreteAggregate implements Aggregate {
	//容纳对象的容器
	private Vector vector = new Vector();
	
	//增加一个元素
	@Override
	public void add(Object object) {
		this.vector.add(object);
	}

	//返回迭代器对象
	@Override
	public Iterator iterator() { //createIterator()
		return new ConcreteIterator(this.vector);
	}

	//删除一个元素
	@Override
	public void remove(Object object) {
		this.remove(object);
	}

}
