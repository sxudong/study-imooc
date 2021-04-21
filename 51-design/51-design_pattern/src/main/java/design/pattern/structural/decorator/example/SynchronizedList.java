package design.pattern.structural.decorator.example;

import design.annoations.ThreadSafe;

@ThreadSafe
public class SynchronizedList<E> implements List<E> {
	private final List<E> list;

	public SynchronizedList(List<E> list) {
		this.list = list;
	}

	@Override
	public synchronized void add(E e) {
		this.list.add(e);
	}

	@Override
	public synchronized E remove(int index) {
		return this.list.remove(index);
	}

	@Override
	public synchronized E get(int index) {
		return this.list.get(index);
	}

	@Override
	public synchronized int size() {
		return this.list.size();
	}

	@Override
	public synchronized String toString() {
		return this.list.toString();
	}
}
