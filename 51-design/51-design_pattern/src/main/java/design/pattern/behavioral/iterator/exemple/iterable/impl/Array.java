package design.pattern.behavioral.iterator.exemple.iterable.impl;

import design.pattern.behavioral.iterator.exemple.iterable.Iterable;
import design.pattern.behavioral.iterator.exemple.iterator.Iterator;

public class Array<E> implements Iterable<E> {
	private Object[] table;

	public Array(E... data) {
		table = data;
	}

	@Override
	public Iterator<E> createIterator() {
		return new ArrayIterator<>();
	}

	//实现Iterator
	private class ArrayIterator<E> implements Iterator<E>{
		private int index;
		@Override
		public boolean hasNext() {
			return index < table.length;
		}

		@Override
		public E next() {
			return (E) table[index++];
		}
	}
}
