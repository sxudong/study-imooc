// TIJ4code
//: io/ChangeSystemOut.java
// Turn System.out into a PrintWriter.
// 将System.out转换为PrintWriter。
package io.print;

import java.io.PrintWriter;

/**
 * 18.8 标准I/O
 * 18.8.2 将 System.out 转换成 PrintWriter
 */
public class ChangeSystemOut {
    public static void main(String[] args) {
        // 第二个参数为true,以便开启自动清空功能；否则，你可能看不到输出
        PrintWriter out = new PrintWriter(System.out, true);
        out.println("Hello, world");
    }
} /* Output:
Hello, world
*///:~
