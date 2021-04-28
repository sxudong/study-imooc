package com.myimooc.java.security.md;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.digest.DigestUtils;
import org.bouncycastle.crypto.Digest;
import org.bouncycastle.crypto.digests.MD5Digest;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.Security;

/**
 * MD消息摘要加密演示
 * 《Java实现消息摘要算法加密》：https://www.imooc.com/learn/286
 *
 * @Date 2016-10-12
 */
public class DemoMd {

    /**
     * 待加密的“字符串”
     */
    private static String src = "imooc security md";

    public static void main(String[] args) {
        jdkMd5(); //89048f19b72e7367b7faacfe659a8de0
        jdkMd2(); //54ade03d9765c9f0290189a2ae704ee7
        bcMd4();  //d4878ee1ed8379537813b3888320ad04
        bcMd5();  //89048f19b72e7367b7faacfe659a8de0
        ccMd5();  //89048f19b72e7367b7faacfe659a8de0
        ccMd2();  //54ade03d9765c9f0290189a2ae704ee7
    }

    /**
     * 通过 jdk 实现 MD5加密
     */
    private static void jdkMd5() {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] md5Bytes = md.digest(src.getBytes());
            //md5Bytes需要把它转化成十六进制，通过第三方包把它转化为十六进制
            System.out.println("JDK MD5:" + Hex.encodeHexString(md5Bytes));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过 jdk 实现 MD2 加密
     */
    private static void jdkMd2() {
        try {
            MessageDigest md = MessageDigest.getInstance("MD2");
            byte[] md2Bytes = md.digest(src.getBytes());
            System.out.println("JDK MD2:" + Hex.encodeHexString(md2Bytes));

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过 bouncy castle 实现 MD5 加密
     */
    private static void bcMd5() {
        Digest digest = new MD5Digest();
        digest.update(src.getBytes(), 0, src.getBytes().length);
        byte[] md5Bytes = new byte[digest.getDigestSize()];
        digest.doFinal(md5Bytes, 0);
        System.out.println("BC MD5:" + org.bouncycastle.util.encoders.Hex.toHexString(md5Bytes));
    }

    /**
     * 通过 bouncy castle 实现 MD4 加密
     */
    private static void bcMd4() {
        try {
            //Java安全 添加一个 Provider（参见：1.5 Java安全组成 -- 包及第三方扩展）
            //动态的添加Provider
            Security.addProvider(new BouncyCastleProvider());
            //MessageDigest是JDK里面的
            MessageDigest md = MessageDigest.getInstance("MD4");
            //接下来跟JDK的操作是一样的了
            byte[] md5Bytes = md.digest(src.getBytes());
            System.out.println("BC MD4:" + org.bouncycastle.util.encoders.Hex.toHexString(md5Bytes));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过 commons codec 实现 MD5 加密
     * cc简化了操作，底层是JDK的实现
     */
    private static void ccMd5() {
        //返回的就是十六制的字符串，省去JDK的手动转换十六进制
        System.out.println("CC MD5:" + DigestUtils.md5Hex(src.getBytes()));
    }

    /**
     * 通过 commons codec 实现 MD5 加密
     */
    private static void ccMd2() {
        System.out.println("CC MD2:" + DigestUtils.md2Hex(src.getBytes()));
    }
}
