package io.object;

import java.io.*;

/**
 * 序列化对象写入到 testobjectio.dat 文件中
 *
 * ObjectOutputStream 类中源码：
 * private void writeObject0(Object obj, boolean unshared) throws IOException {
 *     // ...
 *             // remaining cases
 *             if (obj instanceof String) {
 *                 writeString((String) obj, unshared);
 *             } else if (cl.isArray()) {
 *                 writeArray(obj, desc, unshared);
 *             } else if (obj instanceof Enum) {
 *                 writeEnum((Enum) obj, desc, unshared);
 *             } else if (obj instanceof Serializable) {  // obj是不是一个 Serializable？
 *                 writeOrdinaryObject(obj, desc, unshared);
 *             } else {
 *                 if (extendedDebugInfo) {
 *                     throw new NotSerializableException(
 *                         cl.getName() + "\n" + debugInfoStack.toString());
 *                 } else {
 *                     throw new NotSerializableException(cl.getName());
 *                 }
 *             }
 *     // ...
 * }
 */
public class TestObjectIO {
	public static void main(String args[]) throws Exception {
		T t = new T();
		t.k = 8;
		FileOutputStream fos =
				new FileOutputStream("E:\\xp\\test\\testobjectio.dat");

		// 序列化
		// ObjectOutputStream 专门用来与 Object 的
		ObjectOutputStream oos = new ObjectOutputStream(fos); 
		oos.writeObject(t);
		oos.flush();
		oos.close();

		// 返序列化
		FileInputStream fis = 
				new FileInputStream("E:\\xp\\test\\testobjectio.dat");
		ObjectInputStream ois = new ObjectInputStream(fis);
		T tReaded = (T)ois.readObject();
		System.out.println(tReaded.i + " " 
							+ tReaded.j + " " 
							+ tReaded.d + " " 
							+ tReaded.k); // 10 9 2.3 0
	}
}

class T implements Serializable { // Serializable 可以被序列化
	int i = 10;
	int j = 9;
	double d = 2.3;
	transient int k = 15; // transient：透明的，修饰的成员变量在序列化时不予考虑
}