// TIJ4code
//: io/FormattedMemoryInput.java
package io.ByteArray;

import io.util.BufferedInputFile;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.EOFException;
import java.io.IOException;

/**
 * 18.6.3 格式化的内存输入
 *
 * 要读取格式化数据，可以使用 DataInputStream，它是一个面向字节的 I/O类。
 * 因此我们必须使用 InputStream类。我们可以用 InputStream 以字节的形式读
 * 取任何数据（例如一个文件），这里使用的是字符串。
 */
public class FormattedMemoryInput {
    // 运行配置工作目录为当前目录
    public static void main(String[] args)
            throws IOException {
        try {
            DataInputStream in = new DataInputStream(
                    new ByteArrayInputStream(
                            BufferedInputFile.read(
                                    "FormattedMemoryInput.java").getBytes()));
            while (true)
                System.out.print((char) in.readByte());
        } catch (EOFException e) {
            System.err.println("End of stream");
        }
    }
} /* (Execute to see output) *///:~
