package com.myimooc.java.security.rsa;

import org.apache.commons.codec.binary.Base64;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

/**
 * RSA非对称加密演示
 *
 * 《JAVA实现非对称加密》：https://www.imooc.com/learn/288
 * @author zc 2017-04-12
 */
public class DemoRsa {

    public static void main(String[] args) throws Exception {
        jdkRsa();
    }

    private static void jdkRsa() throws Exception {
        // 1.密钥初始化
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(512); //密钥长度
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        RSAPublicKey rsaPublicKey = (RSAPublicKey) keyPair.getPublic(); //公钥
        RSAPrivateKey rsaPrivateKey = (RSAPrivateKey) keyPair.getPrivate(); //私钥
        System.out.println("Public Key: " + Base64.encodeBase64String(rsaPublicKey.getEncoded()));
        System.out.println("Private Key: " + Base64.encodeBase64String(rsaPrivateKey.getEncoded()));


        // 2.私钥加密、公钥解密：加密
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(rsaPrivateKey.getEncoded());
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(pkcs8EncodedKeySpec);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, privateKey); //私钥加密

        // 待加密字符串
        String src = "imooc security rsa";
        byte[] result = cipher.doFinal(src.getBytes());
        System.out.println("私钥加密、公钥解密：加密:" + Base64.encodeBase64String(result));

        // 3.私钥加密、公钥解密：解密
        X509EncodedKeySpec x509EncodedKeySpec = new X509EncodedKeySpec(rsaPublicKey.getEncoded());
        keyFactory = KeyFactory.getInstance("RSA");
        PublicKey publicKey = keyFactory.generatePublic(x509EncodedKeySpec);
        cipher.init(Cipher.DECRYPT_MODE, publicKey); //公钥解密
        result = cipher.doFinal(result);
        System.out.println("私钥加密、公钥解密：解密:" + new String(result));



        // 4.公钥加密、私钥解密：加密
        x509EncodedKeySpec = new X509EncodedKeySpec(rsaPublicKey.getEncoded());
        keyFactory = KeyFactory.getInstance("RSA");
        publicKey = keyFactory.generatePublic(x509EncodedKeySpec);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey); //公钥加密
        result = cipher.doFinal(src.getBytes());
        System.out.println("公钥加密、私钥解密：加密:" + Base64.encodeBase64String(result));

        // 5.公钥加密、私钥解密：解密
        pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(rsaPrivateKey.getEncoded());
        keyFactory = KeyFactory.getInstance("RSA");
        privateKey = keyFactory.generatePrivate(pkcs8EncodedKeySpec);
        cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, privateKey); //私钥解密
        result = cipher.doFinal(result);
        System.out.println("公钥加密、私钥解密：解密:" + new String(result));
    }
}
/* Output:
Public Key: MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAMP9gLASaofZZC9z6Fa5bOGc7GGlyWmZXc0NOw2heg7skoka4sCy055NteKzlRn43nt35XHTkJFgVUv5dhO2fn8CAwEAAQ==
Private Key: MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAw/2AsBJqh9lkL3PoVrls4ZzsYaXJaZldzQ07DaF6DuySiRriwLLTnk214rOVGfjee3flcdOQkWBVS/l2E7Z+fwIDAQABAkB0rOq6ZwxCeXl6Am+TiWm3Wjsi2pZwJhxAYRsBv1qxnLvgErsJljrzt9osbmn+010KiRR/Ygnfuwjiik2vJeY5AiEA4TauSDV5qSLFLPcK4k/sGBC98N42pnMrhnAIuB86O2UCIQDeyCeYRyvhvBMGNJmmX4iPZGTHgIjwe/ccrqhfdXFeEwIhAMeNwgOtjm11p6zeAUDifFoei47f9yCpsAlhP/iVgu2ZAiAHiUvVmerBGySlnBfqiebLuwCxwwZe5EKqxLnLaOSp4wIged/kpmvQKHPEp1v6DFtlsRph48vDWwVwHDbgWnWAn1g=
私钥加密、公钥解密：加密:ezBtfPtpI3lDPa/CuznPoKXuj9a+OgZCgeaohwEt3RaDEBXnUSKMnMy7v3hwScTNjvX8nFspyR3MNkEOv0Q64g==
私钥加密、公钥解密：解密:imooc security rsa
公钥加密、私钥解密：加密:OGenh4OfMS+mr2T/YY7BSsWq+6Xntjk0f/ptoxhNIC1DvYk8nYZc1+m7IfY2HpMWdUl2ra6pPyvPOkd6S7zsig==
公钥加密、私钥解密：解密:imooc security rsa
 */