package io.byteIO;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * 文件字节流，字符集是ASCII码，所以中文乱码
 */
public class TestFileInputStream {
    public static void main(String[] args) {
        int b = 0;
        FileInputStream in = null;
        try {
            in = new FileInputStream("e:/xp/test/Demo03.java");
        } catch (FileNotFoundException e) {
            System.out.println("找不到指定文件");
            System.exit(-1);
        }

        try {
            long num = 0;
            // read()从此输入流中读取一个数据字节。放到b变量中。
            while ((b = in.read()) != -1) {
                // 把这个b强制转换成 char类型 打印出来,读取一个打印一个
                System.out.print((char) b);
                num++;
            }
            in.close();
            System.out.println();
            System.out.println("共读取了 " + num + " 个字节");
        } catch (IOException e1) {
            System.out.println("文件读取错误");
            System.exit(-1); //文件读取错误，系统退出
        }
    }
}