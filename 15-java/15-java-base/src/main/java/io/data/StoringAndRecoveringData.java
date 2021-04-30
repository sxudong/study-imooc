// TIJ4code
//: io/StoringAndRecoveringData.java
package io.data;

import java.io.*;

/**
 * 18.6 I/O流的典型使用方式
 * 18.6.5 存储和恢复数据
 *
 * UTF-8 字符集编码格式:
 *    编码                       长度(Byte)
 *     1    2    3     4        
 * 0xxxxxxx                1
 * 110xxxxx 10xxxxxx            2
 * 1110xxxx 10xxxxxx 10xxxxxx        3
 * 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx   4
 *
 * 从编码中第一列可看出:1.最高位为0时，编码长度为1, 可存放一个ASCII字符。
 *            2.最高位为1，次高位为1，第6位为0时,编码长度为2。
 *             3.最高位为1，次高位为1，第6位为1，第5位为0时,编码长度为3，绝大多数汉字的utf-8编码的长度都为3。
 *              ....以此类推.....
 */
public class StoringAndRecoveringData {
    /**
     * 为了输入可供另一个“流”恢复的数据，我们需要用 DataOutputStream 写入数据，并用 DataInputStream 恢复数据。
     * 这些流可以是任何形式，但在下面的示例中使用的是一个文件，并且对于读和写都进行了缓冲处理。
     * 注意：DataOutputStream 和 DataInputStream 是面向字节的， 因此要使用 InputStream 和 OutputStream。
     */
    public static void main(String[] args) throws IOException {
        DataOutputStream out = new DataOutputStream(
                                    new BufferedOutputStream(
                                            new FileOutputStream("Data.txt"))); //文件自已创建在根目录下
        out.writeDouble(3.14159);
        out.writeUTF("That was pi 汉字");
        out.writeDouble(1.41413);
        out.writeUTF("Square root of 2 汉字");
        out.close();

        DataInputStream in = new DataInputStream(
                                new BufferedInputStream(
                                        new FileInputStream("Data.txt")));
        System.out.println(in.readDouble());
        // Only readUTF() will recover the Java-UTF String properly:
        // 只有readUTF（）才能正确恢复Java-UTF字符串：
        System.out.println(in.readUTF());
        System.out.println(in.readDouble());
        System.out.println(in.readUTF());
    }
} /* Output:
3.14159
That was pi
1.41413
Square root of 2
*///:~
