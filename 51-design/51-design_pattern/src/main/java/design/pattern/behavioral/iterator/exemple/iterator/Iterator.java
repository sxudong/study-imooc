package design.pattern.behavioral.iterator.exemple.iterator;

/**
 * 编写Iterator接口，定义迭代器的功能
 * @param <E>
 */
public interface Iterator<E> {

	// 还有下一个元素吗
	boolean hasNext();

	// 下一个元素
	E next();
}
