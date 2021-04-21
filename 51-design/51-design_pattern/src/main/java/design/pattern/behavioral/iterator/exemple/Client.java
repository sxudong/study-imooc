package design.pattern.behavioral.iterator.exemple;

import design.pattern.behavioral.iterator.exemple.iterable.impl.Array;
import design.pattern.behavioral.iterator.exemple.iterable.impl.Linked;
import design.pattern.behavioral.iterator.exemple.iterator.Iterator;

/**
 * 迭代器模式-遍历容器的统一方式
 * https://javap.blog.csdn.net/article/details/112384288
 */
public class Client {
	// 客户端的遍历变得非常的简单，根本就不关心容器的底层数据结构，
	// 只关心迭代器，只要你还有下一个元素我就继续取。
	public static void main(String[] args) {
		Array array = new Array(1, 2, 3);
		Linked linked = new Linked(1, 2, 3);
		traverse(array.createIterator());
		System.out.println("\n---");
		traverse(linked.createIterator());
	}

	static void traverse(Iterator iterator) {
		while (iterator.hasNext()) {
			System.out.print(iterator.next());
		}
	}
}
/*
123
---
123
 */
