package io.byteIO;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 字节流
 */
public class TestFileOutputStream {
    public static void main(String[] args) {
        int b = 0;
        FileInputStream in = null;
        FileOutputStream out = null;
        try {
            in = new FileInputStream("e:/xp/test/Demo03.java");
			// 没有这个文件，FileOutputStream会自动创建一个
            out = new FileOutputStream("e:/xp/test/HW.java");
            while ((b = in.read()) != -1) {
                out.write(b);
            }
            in.close();
            out.close(); // 管道用完了，记得要关闭
        } catch (FileNotFoundException e2) {
            System.out.println("找不到指定文件");
            System.exit(-1);
        } catch (IOException e1) {
            System.out.println("文件复制错误");
            System.exit(-1);
        }
        System.out.println("文件已复制");
    }
}