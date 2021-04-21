package design.pattern.structural.decorator.example;

public interface List<E> {

	// 添加元素
	void add(E e);

	// 删除元素
	E remove(int index);

	// 获取元素
	E get(int index);

	// 元素个数
	int size();
}
