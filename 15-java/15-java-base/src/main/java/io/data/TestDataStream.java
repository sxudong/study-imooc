package io.data;

import java.io.*;

/**
 * DataInputStream 和 DataOutputStream 属于处理流，需要分别 “套接” 在 InputStream 和 OutputStream 类型的节点流上。
 * DataInputStream 和 DataOutputStream 提供了可以存取与机器无关的 Java 原始类型数据的方法
 */
public class TestDataStream {
    public static void main(String[] args) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(baos);
        try {
            dos.writeDouble(Math.random()); //写Double数占8个字节
            dos.writeBoolean(true); //写入boolean占1个字节

            ByteArrayInputStream bais =
                    new ByteArrayInputStream(baos.toByteArray());

            // available() 返回可从此输入流读取了多少个有效字节。
            System.out.println(bais.available()); //9
            DataInputStream dis = new DataInputStream(bais);

            // 先写先读，先进先出
            System.out.println(dis.readDouble());  //0.399475380526671
            System.out.println(dis.readBoolean()); //true
            dos.close();
            dis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}