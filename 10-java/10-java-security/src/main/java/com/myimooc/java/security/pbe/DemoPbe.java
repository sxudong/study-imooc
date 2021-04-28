package com.myimooc.java.security.pbe;

import org.apache.commons.codec.binary.Base64;

import java.security.Key;
import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;

/**
 * PBE对称加密演示
 *
 * 《JAVA实现对称加密》：https://www.imooc.com/learn/287
 * @author zc 2017-04-11
 */
public class DemoPbe {

    private static final String TOKEN = "imooc";

    public static void main(String[] args) throws Exception {
        jdkPbe();
    }

    /**
     * 使用 JDK 实现 PBE 算法加解密
     */
    private static void jdkPbe() throws Exception {
        // 初始化盐
        SecureRandom random = new SecureRandom();
        byte[] salt = random.generateSeed(8);

        // 口令与密钥
        PBEKeySpec pbeKeySpec = new PBEKeySpec(TOKEN.toCharArray());
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBEWITHMD5andDES");
        Key key = factory.generateSecret(pbeKeySpec);

        // 加密 (md笔记表格中的参数)
        PBEParameterSpec pbeParameterSpec = new PBEParameterSpec(salt, 100);
        Cipher cipher = Cipher.getInstance("PBEWITHMD5andDES");
        cipher.init(Cipher.ENCRYPT_MODE, key, pbeParameterSpec);

        // 待加密字符串
        String src = "imooc security pbe";
        byte[] enResult = cipher.doFinal(src.getBytes());
        System.out.println("jdk pbe encrypt:" + Base64.encodeBase64String(enResult));

        // 解密
        cipher.init(Cipher.DECRYPT_MODE, key, pbeParameterSpec); //重新初始化，同一个秘钥
        byte[] deResult = cipher.doFinal(enResult);
        System.out.println("jdk pbe decrypt:" + new String(deResult));
    }
}
/* Output:
jdk pbe encrypt:YxWkZRNBvb1z85nTCecNEbDPiuBBDe0i
jdk pbe decrypt:imooc security pbe
 */