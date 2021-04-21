package io.print;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * 封装输入
 */
public class BuffereIn {

    public static void main(String[] args) throws IOException {
        InputStream is = System.in;
        BufferedReader br = new BufferedReader(new InputStreamReader(is));
        System.out.println("请输入。。。。");
        String msg = br.readLine(); //读取控制台输入
        System.out.println(msg);
    }
}
