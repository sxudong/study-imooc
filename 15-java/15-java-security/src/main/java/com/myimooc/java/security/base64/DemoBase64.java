package com.myimooc.java.security.base64;

import org.apache.commons.codec.binary.Base64;

/**
 * Base64加密演示
 *
 * 慕课网《Java实现Base64加密》https://www.imooc.com/learn/285
 * @Date 2016-10-12
 */
public class DemoBase64 {

    /**
     * 待加密的“原始的字符串”
     */
    private static String src = "imooc security base64";

    public static void main(String[] args) {
        jdkBase64();
        commonsCodesBase64();
        bouncyCastleBase64();
    }

    /**
     * 通过JDK实现Base64加密
     */
    private static void jdkBase64() {
        //编码
        java.util.Base64.Encoder encoder = java.util.Base64.getEncoder();
        byte[] encode1 = encoder.encode(src.getBytes());
        String encode = new String(encode1);
        System.out.println("encode:" + encode); //aW1vb2Mgc2VjdXJpdHkgYmFzZTY0

        //解码
        java.util.Base64.Decoder decoder = java.util.Base64.getDecoder();
        byte[] decode = decoder.decode(encode);
        String str = new String(decode);
        System.out.println("decode:" + str); //imooc security base64

    }

    /**
     * 另一个实现方式：通过 Commons codec 实现 Base64 加密
     */
    private static void commonsCodesBase64() {
        //编码
        byte[] encodeBytes = Base64.encodeBase64(src.getBytes());
        System.out.println("encode:" + new String(encodeBytes));
        //输出：aW1vb2Mgc2VjdXJpdHkgYmFzZTY0

        //解码
        byte[] decodeBytes = Base64.decodeBase64(encodeBytes);
        System.out.println("decode:" + new String(decodeBytes));
        //输出：imooc security base64
    }

    /**
     * 另一个实现方式：通过 Bouncy Castle 实现 Base64 加密
     */
    private static void bouncyCastleBase64() {
        //编码
        byte[] encodeBytes = org.bouncycastle.util.encoders.Base64.encode(src.getBytes());
        System.out.println("encode:" + new String(encodeBytes));
        //输出：aW1vb2Mgc2VjdXJpdHkgYmFzZTY0

        //解码
        byte[] decodeBytes = org.bouncycastle.util.encoders.Base64.decode(encodeBytes);
        System.out.println("decode:" + new String(decodeBytes));
        //输出：imooc security base64
    }
}
