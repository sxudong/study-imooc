package design.pattern.structural.decorator.example;

import design.annoations.NotThreadSafe;

import java.util.StringJoiner;

/**
 * 基于数组的ArrayList实现类
 * @param <E>
 */
@NotThreadSafe
public class ArrayList<E> implements List<E> {
	private Object[] table = new Object[1 << 4];//初始容量
	private int size;

	@Override
	public void add(E e) {
		table[size++] = e;
		if (size >= table.length) {
			// 扩容
			Object[] newTable = new Object[table.length << 1];
			System.arraycopy(table, 0, newTable, 0, table.length);
			table = newTable;
		}
	}

	@Override
	public E remove(int index) {
		E oldValue = (E) table[index];
		int numMoved = size - index - 1;
		if (numMoved > 0)
			System.arraycopy(table, index + 1, table, index, numMoved);
		table[--size] = null;
		return oldValue;
	}

	@Override
	public E get(int index) {
		if (index >= size) {
			throw new IndexOutOfBoundsException("size:" + size + ",index:" + index);
		}
		return (E) table[index];
	}

	@Override
	public int size() {
		return size;
	}

	@Override
	public String toString() {
		StringJoiner sj = new StringJoiner(",");
		for (int i = 0; i < size; i++) {
			sj.add(table[i].toString());
		}
		return "{" + sj + "}";
	}
}
