// TIJ4code
//: io/Echo.java
// How to read from standard input.
// 如何从标准输入读取。
// {RunByHand}
package io.print;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * 18.8 标准I/O
 * 18.8.1 从标准输入中读取 —— System.in
 *
 */
public class Echo {
    public static void main(String[] args)
            throws IOException {
        BufferedReader stdin = new BufferedReader(
                                    new InputStreamReader(System.in));
        String s;
        while ((s = stdin.readLine()) != null && s.length() != 0)
            System.out.println(s);
        // An empty line or Ctrl-Z terminates the program
    }
} ///:~
