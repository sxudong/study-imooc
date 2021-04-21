package io.convert;

import java.io.UnsupportedEncodingException;

/**
 * 转换流
 *
 * - InputStreamReader 和 OutputStreamWriter 用与 字节数据 字符数据 之间的 转换。
 *
 * - InputStreamReader 需要和 InputStream “套接”。
 *   - InputStreamReader 的作用是把 InputStream 转换成 Reader
 *
 * - OutpSreamWriter 需要和 OutputStrem "套接"。
 *   - OutputStreamWriter 的作用是把 OutputStream 转换成 Writer
 *
 * - 不存在把字符流转换成字节流的转换流，因为没有必要。
 * - System.in代表标准输入， 即键盘输入。
 *
 * - 转换流在构造时可以指定其编码集合，例如：
 *   Reader reader = new InputStreamReader(System.in, "ISO8859_1")
 */
public class ConverDemo01 {

    /**
     * 字节缓冲流
     */
    public static void main(String[] args) throws UnsupportedEncodingException {
        String str = "中国";
        byte[] data = str.getBytes();
        // length 字节数不完整（UTF-8 一个字符是3个字节长度）
        System.out.println(new String(data, 0, 4)); // 中
        //System.out.println(new String(data, 0, data.length)); // 中国
        test1();
    }

    /**
     * 编码与解码字符集必须相同，否则乱码
     */
    public static void test1() throws UnsupportedEncodingException {
        // 解码 byte --> char
        String str = "中国"; //gbk
        // 编码 char --> byte
        byte[] data = str.getBytes();
        // 编码与解码字符集同一
        System.out.println(new String(data)); //中国

        data = str.getBytes("utf-8"); //设定编码字符集
        // 不同一出现乱码
        System.out.println(new String(data));//中国

        // 编码
        byte[] data2 = "中国".getBytes("utf-8");
        // 解码
        str = new String(data2, "utf-8");
        System.out.println(str);//中国
    }

}
