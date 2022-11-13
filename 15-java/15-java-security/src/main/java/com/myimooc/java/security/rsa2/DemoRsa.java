package com.myimooc.java.security.rsa2;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

/**
 * RSA数字签名算法演示
 *
 * @author zc 2017-04-12
 */
public class DemoRsa {

    public static void main(String[] args) throws Exception {
        jdkRsa();
    }

    /**
     * 使用 JDK 实现 RSA 数字签名
     */
    private static void jdkRsa() throws Exception {
        // 1.初始化密钥
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(512); //密钥长度
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        RSAPublicKey rsaPublicKey = (RSAPublicKey) keyPair.getPublic(); //公钥
        RSAPrivateKey rsaPrivateKey = (RSAPrivateKey) keyPair.getPrivate(); //私钥
        System.out.println("Public Key: " + Base64.encodeBase64String(rsaPublicKey.getEncoded()));
        System.out.println("Private Key: " + Base64.encodeBase64String(rsaPrivateKey.getEncoded()));

        // 2.执行签名
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(rsaPrivateKey.getEncoded());
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(pkcs8EncodedKeySpec);
        Signature signature = Signature.getInstance("MD5withRSA"); //签名
        signature.initSign(privateKey);

        // 待加密字符串
        String src = "imooc security rsa";
        signature.update(src.getBytes());
        byte[] result = signature.sign();
        System.out.println("jdk ras sign:" + Hex.encodeHexString(result));

        // 3.验证签名
        X509EncodedKeySpec x509EncodedKeySpec = new X509EncodedKeySpec(rsaPublicKey.getEncoded());
        keyFactory = KeyFactory.getInstance("RSA");
        PublicKey publicKey = keyFactory.generatePublic(x509EncodedKeySpec);
        signature = Signature.getInstance("MD5withRSA");
        signature.initVerify(publicKey);
        signature.update(src.getBytes());
        boolean bool = signature.verify(result);
        System.out.println("jdk rsa verify:" + bool);
    }
}
/* Output:
Public Key: MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJDxwcg4hz3McTSC6zt4PA1B/dpTyF4b9dPXigTeTOOzku1pI3L+WZXW5t7oX1Viy5HX3JsrI7Nv3+O4RteDlj8CAwEAAQ==
Private Key: MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAkPHByDiHPcxxNILrO3g8DUH92lPIXhv109eKBN5M47OS7Wkjcv5Zldbm3uhfVWLLkdfcmysjs2/f47hG14OWPwIDAQABAkAXx5IDR0Lo4KGx+8ib+R3hDvKW3ygASJYMK1B5e/8hXBRCVpkydpMKxRcc3T8HJ3vPO2NFT0BAimdzfEXX0vABAiEA637/ReKJM86JAjND0exrD3eneYcQr5XnV5v2QGvLnJ0CIQCdkHDUNKdNXZY6uBxE7J9Ig4qc93jMHs2s5uhHd1GxiwIgXgQRfaD3DYvC/vHgfYpZI4+teMMHUlISTdOh+A4Q97ECIGn3GRpt6tIqDX2iEkj8RcczyAX2nMPSN4p/pFlj0oovAiEAoQfL+x7X4cKEr1iqhBkHxm+52ip81A2MQJiKOJvWicI=
jdk ras sign:582b51afe688bdefa98e2ccc9a1058c27f71771eebcbaebc3193a3d2aed931ce1b3d4d371376fb7055be09654da14358dcd110befae69ec03653c30e80749fae
jdk rsa verify:true
 */