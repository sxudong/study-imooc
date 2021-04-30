package io.print;

import java.io.*;

/**
 * 读取文件中的信息打印到控制台
 */
public class TestPrintStream2 {
    public static void main(String[] args) {
        //String filename = args[0];
        //String filename = "E:\\xp\\test\\print.txt";
        //需配置当前文件夹为工作目录 F:\code\JavaIO\src\com\bjsxt\io\print
        String filename = new File("TestPrintStream2.java").getAbsolutePath();
        if (filename != null) {
            list(filename, System.out);
        }
    }

    public static void list(String f, PrintStream fs) {
        try {
            BufferedReader br =
                    new BufferedReader(new FileReader(f));
            String s = null;
            while ((s = br.readLine()) != null) {
                fs.println(s);
            }
            br.close();
        } catch (IOException e) {
            fs.println("无法读取文件");
        }
    }
}