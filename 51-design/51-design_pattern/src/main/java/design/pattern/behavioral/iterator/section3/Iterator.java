package design.pattern.behavioral.iterator.section3;

/**
 * 设计模式之禅——迭代器模式
 * 抽象迭代器
 */
public interface Iterator {
	
	//遍历到下一个元素
	public Object next();
	
	//是否已经遍历到尾部
	public boolean hasNext();
	
	//删除当前指向的元素
	public boolean remove();
}
