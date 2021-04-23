package chap14.HashTable.example6;

import java.util.Objects;

class  SxtEntry {
	Object key;
	Object value;
	
	public SxtEntry(Object key, Object value) {
		super();
		this.key = key;
		this.value = value;
	}

	public Object getKey() {
		return key;
	}

	public void setKey(Object key) {
		this.key = key;
	}

	public Object getValue() {
		return value;
	}

	public void setValue(Object value) {
		this.value = value;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		SxtEntry sxtEntry = (SxtEntry) o;
		return Objects.equals(key, sxtEntry.key) &&
				Objects.equals(value, sxtEntry.value);
	}

	@Override
	public int hashCode() {
		return Objects.hash(key, value);
	}
}