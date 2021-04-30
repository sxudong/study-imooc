package io.charIO;

import java.io.FileWriter;
import java.io.IOException;

/**
 * 文件流 FileWriter
 * 字符流 —— 写入文件
 */
public class TestFileWriter {
    public static void main(String[] args) {
        FileWriter fw = null;
        try {
            fw = new FileWriter("E:\\xp\\test\\unicode.dat");
            for (int c = 0; c <= 50000; c++) { //计算机内部是内数字来表示的
                fw.write(c); //public void write(String str),打印0~5000的unicode字符集
            }
            fw.close();
        } catch (IOException e1) {
            e1.printStackTrace();
            System.out.println("文件写入错误");
            System.exit(-1);
        }
    }
}