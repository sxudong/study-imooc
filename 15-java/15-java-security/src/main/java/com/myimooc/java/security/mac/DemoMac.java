package com.myimooc.java.security.mac;

import org.apache.commons.codec.binary.Hex;
import org.bouncycastle.crypto.digests.MD5Digest;
import org.bouncycastle.crypto.macs.HMac;
import org.bouncycastle.crypto.params.KeyParameter;

import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

/**
 * MAC消息摘要加密演示
 *
 * 《Java实现消息摘要算法加密》：https://www.imooc.com/learn/286
 * @Date 2016-10-12
 */
public class DemoMac {

    /**
     * 待加密的“原始的字符串”
     */
    private static String src = "imooc security mac";

    public static void main(String[] args) throws Exception {
        jdkHmacMd5(); //jdk hmacMD5:e0e18002e9b9970598d0bd3adcfba409
        bcHmacMd5();  //bc  hmacMD5:e0e18002e9b9970598d0bd3adcfba409
    }

    /**
     * jdk实现hmac MD5摘要算法
     */
    private static void jdkHmacMd5() throws Exception {
//        KeyGenerator keyGenerator = KeyGenerator.getInstance("HmacMD5"); //初始化KeyGenerator
//        SecretKey secretKey = keyGenerator.generateKey(); //产生秘钥
//        byte[] key = secretKey.getEncoded(); //获得秘钥
        // 使用自定义密钥
        byte[] key = Hex.decodeHex(new char[]{'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a'});

        // 还原密钥
        SecretKey restoreSecretKey = new SecretKeySpec(key, "HmacMD5");
        // 实例化 MAC
        Mac mac = Mac.getInstance(restoreSecretKey.getAlgorithm());
        // 初始化 MAC
        mac.init(restoreSecretKey);
        // 执行摘要
        byte[] hmacMd5Bytes = mac.doFinal(src.getBytes());
        System.out.println("jdk hmacMD5:" + Hex.encodeHexString(hmacMd5Bytes));
        //jdk hmacMD5:e0e18002e9b9970598d0bd3adcfba409
    }

    /**
     * Bouncy Castle crypto实现hmacMD5加密
     */
    private static void bcHmacMd5() {
        HMac hmac = new HMac(new MD5Digest());
        hmac.init(new KeyParameter(org.bouncycastle.util.encoders.Hex.decode("aaaaaaaaaa")));
        hmac.update(src.getBytes(), 0, src.getBytes().length);
        // 执行摘要
        byte[] hmacMd5Bytes = new byte[hmac.getMacSize()];
        hmac.doFinal(hmacMd5Bytes, 0);
        System.out.println("bc   hmacMD5:" + org.bouncycastle.util.encoders.Hex.toHexString(hmacMd5Bytes));
        //bc  hmacMD5:e0e18002e9b9970598d0bd3adcfba409
    }
}
