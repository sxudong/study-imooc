package com.myimooc.java.security.sha;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.digest.DigestUtils;
import org.bouncycastle.crypto.Digest;
import org.bouncycastle.crypto.digests.SHA1Digest;
import org.bouncycastle.crypto.digests.SHA224Digest;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.Security;

/**
 * SHA消息摘要加密演示
 *
 * 《Java实现消息摘要算法加密》：https://www.imooc.com/learn/286
 * @Date 2016-10-12
 */
public class DemoSha {

    /**
     * 待加密的“原始的字符串”
     */
    private static String src = "imooc security sha";

    public static void main(String[] args) {
        jdkSha1();   //8bb95fe138f7e9d993dd90bae339a45e56b72eb7
        bcSha1();    //8bb95fe138f7e9d993dd90bae339a45e56b72eb7
        bcSha224();  //0b71cc6f590e1d026c922a99081a14e2c58818f4047dae6db3cf3d67
        bcSha2242(); //0b71cc6f590e1d026c922a99081a14e2c58818f4047dae6db3cf3d67
        ccSha1();
    }

    /**
     * 通过 JDK 实现SHA-1 加密
     */
    private static void jdkSha1() {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA");
            md.update(src.getBytes());
            System.out.println("jdk sha-1:" + Hex.encodeHexString(md.digest()));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过 bouncy castle 实现 SHA-1 加密
     */
    private static void bcSha1() {
        Digest digest = new SHA1Digest();
        digest.update(src.getBytes(), 0, src.getBytes().length);
        byte[] sha1Bytes = new byte[digest.getDigestSize()];
        digest.doFinal(sha1Bytes, 0);
        //转换为十六进制
        System.out.println("bc sha-1:" + org.bouncycastle.util.encoders.Hex.toHexString(sha1Bytes));
    }

    /**
     * 通过 bouncy castle 实现 SHA-224 加密
     */
    private static void bcSha224() {
        Digest digest = new SHA224Digest();
        digest.update(src.getBytes(), 0, src.getBytes().length);
        byte[] sha224Bytes = new byte[digest.getDigestSize()];
        digest.doFinal(sha224Bytes, 0);
        System.out.println("bc sha-224:" + org.bouncycastle.util.encoders.Hex.toHexString(sha224Bytes));
    }

    /**
     * 通过 provider 实现 SHA224 加密
     */
    private static void bcSha2242() {
        Security.addProvider(new BouncyCastleProvider());
        try {
            MessageDigest md = MessageDigest.getInstance("SHA224");
            byte[] sha224Bytes = md.digest(src.getBytes());
            System.out.println("bc sha-224:" + org.bouncycastle.util.encoders.Hex.toHexString(sha224Bytes));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过 commons.codec 实现 SHA-1 加密
     * cc简化了操作，底层是JDK的实现
     */
    private static void ccSha1() {
        System.out.println("cc sha1-1:" + DigestUtils.sha1Hex(src.getBytes()));
        System.out.println("cc sha1-2:" + DigestUtils.sha1Hex(src));
        //cc sha1-1:8bb95fe138f7e9d993dd90bae339a45e56b72eb7
        //cc sha1-2:8bb95fe138f7e9d993dd90bae339a45e56b72eb7
    }
}
/* Output:
jdk sha-1:8bb95fe138f7e9d993dd90bae339a45e56b72eb7
bc sha-1:8bb95fe138f7e9d993dd90bae339a45e56b72eb7
bc sha-224:0b71cc6f590e1d026c922a99081a14e2c58818f4047dae6db3cf3d67
bc sha-224:0b71cc6f590e1d026c922a99081a14e2c58818f4047dae6db3cf3d67
cc sha1-1:8bb95fe138f7e9d993dd90bae339a45e56b72eb7
cc sha1-2:8bb95fe138f7e9d993dd90bae339a45e56b72eb7
 */