package io.charIO;

import java.io.FileReader;
import java.io.FileWriter;

/**
 * 字符流 复制文件
 */
public class TestFileWriter2 {
	public static void main(String[] args) throws Exception {
		FileReader fr = new FileReader("d:/java/io/TestFileWriter2.java");
		FileWriter fw = new FileWriter("d:/java/io/TestFileWriter2.bak");
		int b;
		while((b = fr.read()) != -1) {
			fw.write(b);
		}
		fr.close();
		fw.close();
	}
}