package io.buffered;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * 缓冲流要 “套接” 在相应的节点流之上，对读写的数据提供了缓冲的功能，提高了读写的效率，同时增加了一些新的方法。
 *
 * 1. 字节缓冲流
 *    BufferedInputStream / BufferedOutputStream
 *
 * 2. 字符缓冲流
 *    BufferedReader   readLine()
 *    BufferedWriter    newLine()
 */
public class TestBufferStream1 {
	/**
	 * 字节缓冲流
	 */
    public static void main(String[] args) {
        try {
            FileInputStream fis =
                    new FileInputStream("E:/xp/test/Demo03.java");
            BufferedInputStream bis =
                    new BufferedInputStream(fis);
            int c = 0;
			// 读一个出来
            System.out.println(bis.read()); //112 p
            System.out.println(bis.read()); //97 a

			// 从100开始往外读
            bis.mark(100);
            for (int i = 0; i <= 10 && (c = bis.read()) != -1; i++) {
                System.out.print((char) c + " "); // 将 “数字” 强制转换为 “字符” 打出
            }
            System.out.println();

            bis.reset(); // 回到标记的点上，回到100上
            for (int i = 0; i <= 10 && (c = bis.read()) != -1; i++) {
                System.out.print((char) c + " ");
            }
            bis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
/* Output:
112
97
c k a g e   i o . b u
c k a g e   i o . b u
 */