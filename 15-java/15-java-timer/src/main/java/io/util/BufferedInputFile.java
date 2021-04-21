//: io/BufferedInputFile.java
package io.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * 18.6.1 缓冲输入文件
 */
public class BufferedInputFile {
    // Throw exceptions to console:
    // 向控制台抛出异常：
    public static String read(String filename) throws IOException {
        // Reading input by lines:
        // 按行读取输入：
        BufferedReader in = new BufferedReader(
                                    new FileReader(filename));
        String s;
        StringBuilder sb = new StringBuilder();
        // readLine()返回null，就达到了文件的末尾
        while ((s = in.readLine()) != null)
            sb.append(s + "\n"); // 添加换行符
        in.close(); // 关闭文件
        return sb.toString();
    }

    public static void main(String[] args) throws IOException {
        System.out.print(read("BufferedInputFile.java"));
    }
} /* (Execute to see output) *///:~
/* Output:
//: io/BufferedInputFile.java
package io;

import java.io.*;

public class BufferedInputFile {
    // Throw exceptions to console:
    // 向控制台抛出异常：
    public static String
    read(String filename) throws IOException {
        // Reading input by lines:
        // 按行读取输入：
        BufferedReader in = new BufferedReader(
                new FileReader(filename));
        String s;
        StringBuilder sb = new StringBuilder();
        while ((s = in.readLine()) != null)
            sb.append(s + "\n");
        in.close();
        return sb.toString();
    }

    public static void main(String[] args) throws IOException {
        System.out.print(read("BufferedInputFile.java"));
    }
} /* (Execute to see output) *///:~

