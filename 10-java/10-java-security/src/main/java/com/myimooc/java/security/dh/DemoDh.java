package com.myimooc.java.security.dh;

import org.apache.commons.codec.binary.Base64;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.util.Objects;

import javax.crypto.Cipher;
import javax.crypto.KeyAgreement;
import javax.crypto.SecretKey;
import javax.crypto.interfaces.DHPublicKey;
import javax.crypto.spec.DHParameterSpec;

/**
 * DH非对称加密演示 (密钥交换)
 *
 * 《JAVA实现非对称加密》：https://www.imooc.com/learn/288
 * @author zc 2017-04-12
 */
public class DemoDh {

    public static void main(String[] args) throws Exception {
        jdkDh();
    }

    /**
     * 使用 jdk 实现 DH 非对称加密
     */
    private static void jdkDh() throws Exception {
        // 1.初始化发送方密钥
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("DH");
        keyPairGenerator.initialize(512); // 长度
        KeyPair senderKerPair = keyPairGenerator.generateKeyPair();
        // 发送方公钥，发送给接收方（网络、U盘文件...）
        byte[] senderPublicKeyEnc = senderKerPair.getPublic().getEncoded();

        // 2.初始化接收方密钥
        KeyFactory receiverKeyFactory = KeyFactory.getInstance("DH");
        X509EncodedKeySpec x509EncodedKeySpec = new X509EncodedKeySpec(senderPublicKeyEnc);
        PublicKey receiverPublicKey = receiverKeyFactory.generatePublic(x509EncodedKeySpec);
        DHParameterSpec dhParameterSpec = ((DHPublicKey) receiverPublicKey).getParams(); //从发送中解析出来的参数
        KeyPairGenerator receiverKeyPairGenerator = KeyPairGenerator.getInstance("DH");
        receiverKeyPairGenerator.initialize(dhParameterSpec);
        KeyPair receiverKeyPair = receiverKeyPairGenerator.generateKeyPair();
        PrivateKey receiverPrivateKey = receiverKeyPair.getPrivate();
        byte[] receiverPublicKeyEnc = receiverKeyPair.getPublic().getEncoded(); // 发送方公钥

        // 3.密钥构建
        KeyAgreement receiverKeyAgreement = KeyAgreement.getInstance("DH");
        receiverKeyAgreement.init(receiverPrivateKey);
        receiverKeyAgreement.doPhase(receiverPublicKey, true);
        SecretKey receiverDesKey = receiverKeyAgreement.generateSecret("DES"); // 生成本地秘钥

        KeyFactory senderKeyFactory = KeyFactory.getInstance("DH");
        x509EncodedKeySpec = new X509EncodedKeySpec(receiverPublicKeyEnc);
        PublicKey senderPublicKey = senderKeyFactory.generatePublic(x509EncodedKeySpec);

        KeyAgreement senderKeyAgreement = KeyAgreement.getInstance("DH");
        senderKeyAgreement.init(senderKerPair.getPrivate());
        senderKeyAgreement.doPhase(senderPublicKey, true);
        SecretKey senderDesKey = senderKeyAgreement.generateSecret("DES"); // 生成本地秘钥

        if(Objects.equals(receiverDesKey,senderDesKey)) {
            System.out.println("双方密钥相同");
        }
        // 4.加密
        Cipher cipher = Cipher.getInstance("DES");
        cipher.init(Cipher.ENCRYPT_MODE, senderDesKey);

        // 待加密字符串
        String src = "imooc security dh";
        byte[] result = cipher.doFinal(src.getBytes());
        System.out.println("jdk dh encrypt:" + Base64.encodeBase64String(result));

        // 5.解密
        cipher.init(Cipher.DECRYPT_MODE, receiverDesKey);
        result = cipher.doFinal(result);
        System.out.println("jdk dh decrypt:" + new String(result));
    }
    /*
    java在运用DH密钥交换算法时出现“Unsupported secret key algorithm：DES”错误的解决办法:
    Exception in thread "main" java.security.NoSuchAlgorithmException: Unsupported secret key algorithm: DES
        at com.sun.crypto.provider.DHKeyAgreement.engineGenerateSecret(DHKeyAgreement.java:387)
        at javax.crypto.KeyAgreement.generateSecret(KeyAgreement.java:648)
        at com.myimooc.java.security.dh.DemoDh.jdkDh(DemoDh.java:55)
        at com.myimooc.java.security.dh.DemoDh.main(DemoDh.java:26)

        密钥所用的算法不被支持，这个是由于JDK8 update 161之后，DH的密钥长度至少为512位，但AES算法密钥不能达到这样的长度，长度不一致所以导致报错。
        解决的方法：
        将 -Djdk.crypto.KeyAgreement.legacyKDF=true 写入JVM系统变量中。
     */

}
/* Output:
双方密钥相同
jdk dh encrypt:FMcCmvvSm51HwMfPHSfiy+Er5fncA000
jdk dh decrypt:imooc security dh
 */