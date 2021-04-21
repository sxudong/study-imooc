package design.pattern.behavioral.iterator.exemple.iterable;

import design.pattern.behavioral.iterator.exemple.iterator.Iterator;

/**
 * 编写Iterable，代表容器是支持迭代器遍历的
 * @param <E>
 */
public interface Iterable<E> {
	// 创建迭代器
	Iterator<E> createIterator();
}
