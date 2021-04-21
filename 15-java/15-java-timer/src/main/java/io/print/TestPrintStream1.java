package io.print;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;

/**
 * System.setOut() 重新分配 “标准” 输出流, 打印到 ps 流到 log.dat 里去.
 */
public class TestPrintStream1 {
    public static void main(String[] args) {
        //字节输出流
        PrintStream ps = null;
        try {
            FileOutputStream fos =
                    new FileOutputStream("E:\\xp\\test\\log.dat");
            ps = new PrintStream(fos); //ps指向PrintStream(fos)
        } catch (IOException e) {
            e.printStackTrace();
        }
        //默认 System.out, 将输出打印到屏幕窗口里
        //System.setOut(ps)，把System.out的值改掉了，System.out指向了ps
        if (ps != null) {
            System.setOut(ps); //java.lang 重新分配“标准”输出流,打印到ps流到log.dat里去了
        }
        int ln = 0;
        for (char c = 0; c <= 60000; c++) {
            System.out.print(c + " ");
            if (ln++ >= 100) {
                System.out.println();
                ln = 0;
            }
        }
    }
}