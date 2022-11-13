package com.myimooc.java.security.aes;

import org.apache.commons.codec.binary.Base64;

import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

/**
 * AES对称加密演示
 *
 * 《JAVA实现对称加密》：https://www.imooc.com/learn/287
 * @author zc 2017-04-11
 */
public class DemoAes {

    public static void main(String[] args) {
        jdkAes();
    }

    /**
     * 通过 JDK 实现 AES 对称加密
     */
    private static void jdkAes() {
        try {
            // 1.生成秘钥KEY
            KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
            keyGenerator.init(128); //初始化秘钥长度
            SecretKey secretKey = keyGenerator.generateKey();
            byte[] keyBytes = secretKey.getEncoded();

            // 2.KEY 转换
            Key key = new SecretKeySpec(keyBytes, "AES");

            // 3.加密 (md笔记表格中的参数)
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, key);

            // 4.待加密字符串
            String src = "imooc security aes";
            byte[] result = cipher.doFinal(src.getBytes()); //得到加密结果
            System.out.println("jdk aes encrypt:" + Base64.encodeBase64String(result));

            // 解密
            cipher.init(Cipher.DECRYPT_MODE, key); //重新初始化它，使用相同的秘钥
            result = cipher.doFinal(result);
            System.out.println("jdk aes decrypt:" + new String(result));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void bcAES() {
        // TODO
    }
}
