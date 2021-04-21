package design.pattern.behavioral.iterator.exemple.iterable.impl;

import design.pattern.behavioral.iterator.exemple.iterable.Iterable;
import design.pattern.behavioral.iterator.exemple.iterator.Iterator;
import org.apache.commons.lang3.ArrayUtils;

public class Linked<E> implements Iterable<E> {
	private Node head;

	public Linked(E... data) {
		ArrayUtils.reverse(data);

		Node node = null;
		for (E e : data) {
			head = node = new Node(e, node);
		}
	}

	@Override
	public Iterator<E> createIterator() {
		return new LinkedIterator<>();
	}

	static class Node{
		private Object data;
		protected Node next;

		public Node(Object data, Node next) {
			this.data = data;
			this.next = next;
		}
	}

	//实现Iterator
	private class LinkedIterator<E> implements Iterator<E>{
		private Node current = head;

		@Override
		public boolean hasNext() {
			return current != null;
		}

		@Override
		public E next() {
			Node node = this.current;
			this.current = node.next;
			return (E) node.data;
		}
	}
}