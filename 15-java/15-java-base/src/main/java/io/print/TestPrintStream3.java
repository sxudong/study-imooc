package io.print;

import java.io.*;
import java.util.Date;

/**
 * 将控制台输入的信息打印到 logfile.log 文件中去
 */
public class TestPrintStream3 {
    public static void main(String[] args) {
        String s = null;
        BufferedReader br = new BufferedReader(
                new InputStreamReader(System.in));
        try {
            //默认字符编码 构造 FileWriter 对象。
            FileWriter fw = new FileWriter
                    ("E:\\xp\\test\\logfile.log", true); //Log4J
            PrintWriter log = new PrintWriter(fw); //字符输出流
            while ((s = br.readLine()) != null) { //br.readLine()阻塞等待
                if (s.equalsIgnoreCase("exit")) break;
                System.out.println(s.toUpperCase());
                log.println("-----");
                log.println(s.toUpperCase());
                log.flush();
            }
            log.println("===" + new Date() + "===");
            log.flush();
            log.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}