// TIJ4code
//: io/Redirecting.java
// Demonstrates standard I/O redirection.
package io.print;

import java.io.*;

/**
 * 18.8 标准I/O
 * 18.8.3 标准I/0重定向
 *  - setIn(InputStream)
 *  - setOut(PrintStream)
 *  - setErr(PrintStream)
 *
 *  将读取到的文件内容写入到 test.out 中
 */
public class Redirecting {
    // 运行测试程序，需要在IDEA 右上角锤子图标边的下拉菜单中找到“Edit Configurations”
    // 设置当前工个目录“D:\IDEAworkspase\TIJ4code\src\main\java\io”
    public static void main(String[] args) throws IOException {
        // 创建System.out引用
        PrintStream console = System.out;
        // 将“读的管道”对准在"Redirecting.java"上
        BufferedInputStream in = new BufferedInputStream(
                                        new FileInputStream("Redirecting.java"));
        // 将“写的管道”对准在"test.out"上
        PrintStream out = new PrintStream(
                                new BufferedOutputStream(
                                        new FileOutputStream("test.out")));
        // 重定向标准输入
        System.setIn(in);
        // 重定向标准输出
        System.setOut(out);
        System.setErr(out);

        // 一根管道对在标准输入上
        BufferedReader br = new BufferedReader(
                                new InputStreamReader(System.in));
        String s;
        // 循环读读到标准输入内容
        while ((s = br.readLine()) != null)
            // 控制台窗口没有输出，因为重定向，改成输入到“test.out”文件里面去了
            System.out.println(s);
        out.close(); // Remember this!
        System.setOut(console);
    }
} ///:~
