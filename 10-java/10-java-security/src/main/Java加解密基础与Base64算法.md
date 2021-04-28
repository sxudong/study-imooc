慕课网

《Java实现Base64加密》：<https://www.imooc.com/learn/285>

《Java实现消息摘要算法加密》：https://www.imooc.com/learn/286

《JAVA实现对称加密》：https://www.imooc.com/learn/287

《JAVA实现非对称加密》：https://www.imooc.com/learn/288

# Java加、解密基础与Base64算法

**Base64算法**严格来说并不算加解密算法，通常把它当作初级的简单的方式去使用。最初由邮件衍生而来的。

## 1.1 Java实现Base64加密概述

### 课程包含的内容

- 安全和密码
- 常用安全体系介绍
- 密码分类及java的安全组成
- JDK相关包及第三方扩展
- Base64算法介绍

### 如何学习

- 掌握用法
- 深入理解
- 不断实践
- 反复总结
- 再次深入理解与实践

### 一些资源

- 谷歌 http://www.google.com
- 维基百科 http://zh.wikipedia.org
- 其它...



## 1.2 密码常用术语

### 密码常用术语(一)

- 明文：待加密信息。
- 密文：经过加密后的明文。
- 加密：明文转为密文的过程。
- 加密算法：明文转为密文的转换算法。
- 加密密钥：通过加密算法进行加密操作用的密钥。
- 解密：将密文转为明文的过程。
- 解密算法：密文转为明文的算法。
- 解密密钥：通过解密算法进行解密操作用的密钥。



### 密码常用术语(二)

- 密码分析：截获密文者试图通过分析截获的密文从而推断出原来的明文或密钥的过程。
- 主动攻击：攻击者非法入侵密码系统，采用伪造、修改、删除等手段向系统注入假消息进行欺骗。（对密文具有破坏作用)
- 被动攻击：对一个保密系统采取截获密文并对其进行分析和攻击。（对密文没有破坏作用)
- 密码体制：由明文空间、密文空间、密钥空间、加密算法和解密算法五部分构成。

### 密码常用术语(三)

- 密码协议：也称安全协议，指以密码学为基础的消息交换的通信协议，目的是在网络环境中提供安全的服务。
- 密码系统：指用于加密、解密的系统。
- 柯克霍夫原则：数据的安全基于密钥而不是算法的保密。即系统的安全取决于密钥，对密钥保密，对算法公开。——现代密码学设计的基本原则。



## 1.3 密码分类

### 加解密基础

- 密码分类
- Java安全组成
- 相关java包、类
- 第三方`java`扩展

### 密码分类 —— 时间

- 古典密码∶以字符为基本加密单元。
- 现代密码∶以信息块为基本加密单元。

### 密码分类 —— 保密内容算法

| 名称         | 详细说明                               | 应用领域 | 类别     |
| ------------ | -------------------------------------- | -------- | -------- |
| 受限制算法   | 算法的保密性**基于保持算法的保密**     | 军事领域 | 古典密码 |
| 基于密钥算法 | 保密性**基于对密钥的保密**，算法公开。 |          | 现代密码 |

### 密码分类 —— 密码体制

| 名称           | 别名                       | 详细说明                                                     |
| -------------- | -------------------------- | ------------------------------------------------------------ |
| 对称密码       | 单钥密码或私钥密码         | 指加密密钥与解密密钥相同。**也就是说两个人用同一把钥匙去开锁**。 |
| 非对称密码     | 双钥密码或公钥密码密码算法 | 指加密密钥与解密密钥不同，密钥分公钥、私钥。一个人用一把钥匙锁上锁，开锁的人需要用另一把钥匙去解锁。 |
| 对称密码算法   | 单钥密码算法或私钥密码算法 | 指应用于对称密码的加密、解密算法。                           |
| 非对称密码算法 | 双钥密码算法或公钥         | 指对应于非对称密码的加密、解密算法。                         |

### 密码分类 —— 明文处理方法

- **分组密码**：指加密时将名为分成固定长度的组，用同一密钥和算法**对每一块加密，输出也是固定长度**的密文。多用于网络加密。
- **流密码**：也称序列密码。指加密时**每次加密一位或者一个字节**明文。



### 散列函数

散列函数用来**验证数据的完整性**。

**特点**

- 长度不受限制
- 哈希值容易计算
- 散列运算过程不可逆

### 散列函数相关的算法

- 消息摘要算法MD5等
- SHA——安全散列算法
- MAC——消息认证码算法 (MAC——苹果操作系统)

### 数字签名

主要是针对**以数字的形式存储的消息**进行的处理。

## 1.4 OSI与TCP/IP安全体系

### OSI安全体系

- OSI ( Open SystemInterconnection )

![安全体系](/images/OSI.jpg)



### TCP/IP安全体系

![TCP/IP安全体系](/images/TCP IP安全体系.jpg)

![](/images/安全机制.jpg)

## 1.5 Java安全组成 -- 包及第三方扩展

Java的安全主要由这4部分构成：

- `JCA`(Java Cryptography Architecture Java加密体系结构) 

- `JCE`(Java Cryptography Extension Java加密扩展包)

  在JCA的基础上扩展，提供加密算法、加钥和秘钥管理功能，如：DES、AES、RSA算法通过`JCE`提供。

- `JSSE`(Java Secure Socket Extension Java套接字扩展包)

  `JSSE`提供基于`SSL`的加密功能，主要用于网络传输。

- `JAAS`(Java Authentication and Authentication Service Java鉴别与安全服务)

  提供了在Java这个平台上进行用户的身份认证的功能。



使用`JDK`以外的扩展包需要修改资源文件并增加相关的内容，这是使用`JDK`以外的扩展包的方式之一。

C:\Java\jdk1.8.0_172\jre\lib\security\java.security 里的列表，如下：

```java
security.provider.1=sun.security.provider.Sun
security.provider.2=com.sun.net.ssl.internal.ssl.Providersecurity.provider.3=com.sun.rsajca.Provider
security.provider.4=com.sun.crypto.provider.SunJCEsecurity.provider.5=sun.security.jgss.SunProvider
security.provider.6=org.bouncycastle.jce.provider.BouncyCastleProvider
```

可以在里面加入自已的provider。



### 相关java包、类

- java.security
  - 消息摘要
- javax.crypto 
  - 安全消息摘要，消息认证（鉴别）码
- java.net.ssl
  - 安全套接字，与网络传输相关的加解密操作
    常用的类如：`HttpsURLConnection` 、`SSLContext`



### 第三方Java扩展

- Bouncy Castle
  一两种支持方案:1）配置;2）调用
- Commons Codec（常用）
  - 这个是Apache提供的包
  - 主要支持：Base64、二进制、十六进制、字符集编码
  - Url编码/解码



## 2.1 实现Base64算法 

### 应用

- Base64算法
- 消息摘要算法
- 对称加密算法
- 非对称加密算法
- 数字签名算法
- 数字证书安全协议



### Base64算法

aW1vb2Mgc2VjdXJpdHkgYmFzZTYO（密文）

imooc security base64 （明文）



**算法实现**：

- Jdk
- Commons Codec
- Bouncy Castle

**应用场景**：e-mail、密钥、证书文件

**产生：邮件的“历史问题”**

​           最开始时传输非ASCII码的值在不同的网关会出现一些问题，所以只能传输这种ASCII码的值，所以就产生了`Base64算法`。

**定义：**基于64个字符的编码算法

**关于RFC 2045 规范**

**衍生：Base16、Base32、Url Base64**

**Base64算法与加解密算法**

​     可以充当加解密，但是它算法的计算方式和解码都是公开的。



# Java实现消息摘要算法加密

简介：本课程是《Java实现Base64加密》课程的延续，是Java加解密系列课程的第二门课。

本课程主要介绍如何在Java中使用MD、SHA、MAC三种消息摘要算法实现加解密，以及他们的应用场景。

## 1 概述

### 1.1 Java实现消息摘要算法加密概述

**消息摘要算法**

- MD (Message Digest 信息摘要 )
- SHA ( Secure Hash Algorithm 安全哈希算法 )
- MAC ( Message Authentication Code 消息验证码) 
- 这3类主要的作用是：验证数据完整性
- 消息摘要算法是**整个数字签名核心算法**

下载之后查看一下文件的md5值与网上给定的md5的值是不是一致，如果是一致，说明这个下载文件是完整的，否则是不完整的。



## 2 消息摘要算法 MD

### 2.1 MD算法概述

- MD5

- MD家族(128位摘要信息)

  - MD2、MD4

    

- 特点  长度都是128位，单向加密过程。

| 算法 | 摘要长度 | 实现方        |
| ---- | -------- | ------------- |
| MD2  | 128      | JDK           |
| MD4  | 128      | Bouncy Castle |
| MD5  | 128      | JDK           |



### 2.2 MD算法实现

查看项目代码

### 2.3 MD算法应用

用户注册密码MD之后保存到数据库。

## 3 消息摘要算法 SHA

本章主要介绍消息摘要算法SHA的实现与应用。

### 3.1 SHA算法概述

在MD4的基础上演进而来。

- 安全散列算法
- 固定长度摘要信息
- SHA-1、SHA-2 ( SHA-224、SHA-256、SHA-384、SHA-512 )



| 算法    | 摘要长度 | 实现方        |
| ------- | -------- | ------------- |
| SHA-1   | 160      | JDK           |
| SHA-224 | 224      | Bouncy Castle |
| SHA-256 | 256      | JDK           |
| SHA-384 | 384      | JDK           |
| SHA-512 | 512      | JDK           |



### 3.2 SHA算法实现

看项目代码



### 3.3 SHA算法应用

谷歌浏览器 --> 设置 --> 安全 --> 管理证书   可以查看证书摘要。



![](/images/SHA消息摘要过程.jpg)

#### 应用

1.加入约定Key（给每一个接入方一个key）

2.增加时间戳

3.排序

**约定的消息传送格式，如下：**

http://**?msg=12Hsad74mj&timestamp=1309488734

**msg**：原始消息 + key + 时间戳


这个可以参考微信


## 4 消息摘要算法MAC

### 4.1 消息摘要算法MAC实现与应用

**消息摘要算法 -- MAC**

- MAC ( Message Authentication Code )
- HMAC ( keyed-Hash Message Authentication Code ) ,含有密钥的散列函数算法
- 融合MD、SHA
  - MD系列: HmacMD2、HmacMD4、HmacMD5
  - SHA系列: HmacSHA1、HmacSHA224、HmacSHA256、
    HmacSHA384、HmacSHA512
- 应用如SecureCRT (linux访问的客户端)



MAC只是在MD和SHA两类算法的基础上加入了秘钥，长度和这两类保持一致的。

| 算法       | 摘要长度 | 实现方        |
| ---------- | -------- | ------------- |
| HmacMD2    | 128      | Bouncy Castle |
| HmacMD4    | 128      | Bouncy Castle |
| HmacMD5    | 128      | JDK           |
| HmacSHA1   | 160      | JDK           |
| HmacSHA224 | 224      | Bouncy Castle |
| HmacSHA256 | 256      | JDK           |
| HmacSHA384 | 384      | JDK           |
| HmacSHA512 | 512      | JDK           |

![](/images/MAC消息摘要算法.jpg)



### 其它的消息算法

- RipeMD
- Tiger
- Whirlpool
- GOST3411

如果要使用，只能通过`Bouncy Castle`来实现。



# JAVA实现对称加密

**对称加密**指"加密"和"解密"使用相同密钥的加密算法。本课程中将介绍`DES`、`3重DES`、`AES`和`PBE`几种常见的对称加密算法在Java中的实现，以及他们的应用范围。

## 第1章 对称加密算法DES

### 1.1 JAVA对称加密算法

加官秘钥 = 解密秘钥

对称加密算法它是一种初等的加密算法。

- DES

  - 由于长度不够，衍生出了3DES

- AES

  在DES的基础上又出现了AES算法。

- PBE

- IDEA



#### 对称加密算法 -- DES

**DES**( Data Encryption Standard )数据加密标准。98年之后不断的被破解，实际实用用DES已经不再具备安全性，新做的项目不会选择这个加密算法。

| 密钥长度 | 默认 | 工作模式                                                 | 填充方式                                                     | 实现方 |
| -------- | ---- | -------------------------------------------------------- | ------------------------------------------------------------ | ------ |
| 56       | 56   | ECB、CBC、PCBC、CTR、
CTS、CFB、CFB8到128、OFB、OFB8到128 | NoPadding、PKCS5Padding、ISO10126Padding                     | JDK    |
| 64       | 56   | 同上                                                     | PKCS7Padding、ISO10126d2Padding、X932Padding、ISO7816d4Padding、ZeroBytePadding | BC     |

DES使用步骤:

![](/images/对称加密算法DES.jpg)

## 第2章 对称加密算法3DES

### 对称加密算法—3重DES

3重DES的好处:
     1、密钥长度增强

​     2、迭代次数提高

3重DES应用十分广泛。

- 3DES(Triple DES或DESede)

| 密钥长度 | 默认 | 工作模式                                                 | 填充方式                                                     | 实现方 |
| -------- | ---- | -------------------------------------------------------- | ------------------------------------------------------------ | ------ |
| 112、168 | 168  | ECB、CBC、PCBC、CTR、CTS、CFB、CFB8到128、OFB、OFB8到128 | NoPadding、PKCS5Padding、ISO10126d2Padding                   | JDK    |
| 128、192 | 168  | 同上                                                     | PKCS7Padding、ISO10126Padding、X932Padding、ISO7816d4Padding、ZeroBytePadding | BC     |

## 第3章 对称加密算法AES

### 对称加密算法—AES

AES是目前使用得最多的方式。

AES的优势之一是至今尚未被破解。

AES通常用于移动通信系统加密以及基于SSH协议的软件。比如说：SSH Client、secureCRT



- 高级
- DES替代者

| 密钥长度      | 默认 | 工作模式                                                 | 填充方式                                 | 实现方                                    |
| ------------- | ---- | -------------------------------------------------------- | ---------------------------------------- | ----------------------------------------- |
| 128、192、256 | 128  | ECB、CBC、PCBC、CTR、CTS、CFB、CFB8到128、OFB、OFB8到128 | NoPadding、PKCS5Padding、ISO10126Padding | JDK (256位密钥需要获得无政策限制权限文件) |
| 同上          | 同上 | 同上                                                     | PKCS7Padding、BCZeroBytePadding          |                                           |

**无政策限制权限文件**是指，因为某些国家的进口管制限制，Java发布的运行环境包中的加解密有一定的限制。

AES使用步骤

![](/images/AES使用步骤.jpg)

## 第4章对称加密算法PBE

### 4.1 JAVA对称加密算法PBE

**对称加密算法 -- PBE**

PBE算法结合了消息摘要算法和称密算法的优点。特殊的对称加密算法。

- PBE ( Password Based Encryption)基于口令加密
- 对已有算法的包装
- JDK、BC
- 加盐
- PBEWithMD5AndDES



BC提供的实现：

| 密钥长度                        | 秘钥长度 | 默认 | 工作模式 | 填充方式                                                     | 实现方 |
| ------------------------------- | -------- | ---- | -------- | ------------------------------------------------------------ | ------ |
| PBEWithMD5AndDES                | 64       | 64   | CBC      | PKCS5Padding、PKCS7Padding、ISO10126Padding、ZeroBytePadding | BC     |
| PBEWithMD5AndRC2                | 112      | 128  | CBC      | 同上                                                         | BC     |
| PBEWithSHA1AndDES               | 64       | 64   | CBC      | 同上                                                         | BC     |
| PBEWithSHA1AndRC2               | 128      | 128  | CBC      | 同上                                                         | BC     |
| PBEWithSHAAndIDEA-CBC           | 128      | 128  | CBC      | 同上                                                         | BC     |
| PBEWithSHAAnd2-KeyTripleDES-CBC | 128      | 128  | CBC      | 同上                                                         | BC     |
| PBEWithSHAAnd3-KeyTripleDES-CBC | 192      | 192  | CBC      | 同上                                                         | BC     |

JDK提供的实现：

| 密钥长度               | 秘钥长度         | 默认 | 工作模式 | 填充方式     | 实现方 |
| ---------------------- | ---------------- | ---- | -------- | ------------ | ------ |
| PBEWithMD5AndDES       | 56               | 64   | CBC      | PKCS5Padding | JDK    |
| PBEWithMD5AndTripleDES | 112、168         | 168  | CBC      | 同上         | JDK    |
| PBEWithSHA1AndDESede   | 112、168168      |      | CBC      | 同上         | JDK    |
| PBEWithSHA1AndRC240    | 40~1024（8倍数） | 128  | CBC      | 同上         | JDK    |

PEB使用步骤：

![](/images/PEB使用步骤.jpg)



# JAVA实现非对称加密

简介：**非对称加密算法**是一种基于密钥的保密方法，需要**公开密钥**和**私有密钥**，在文件加密、尤其是网银中应用广泛。本课程主要介绍非对称加密算法的实现过程，DH、RSA和ELGamal等几种常见的非对称加密算法的在Java中的应用。

## 第1章 概述 

**非对称加密算法**

- 高级

- 双保险

- 公钥、私钥

- DH ( Diffie-Hellman )密钥交换算法

- RSA — 基于因子分解

  3个人的名字命名的，目前世界上使用最广泛的非对称加密算法

- ElGamal—基于离散对数

- ECC(Elliptical Curve Cryptography) — 椭圆曲线加密



## 第2章 密钥交换算法DH

### 2.1 DH(Diffie-Hellman)算法概述

**非对称加密算法—DH(密钥交换)**

- 对称加密带来的困扰

- 构建本地密钥

- 对称



| 密钥长度           | 默认 | 工作模式 | 填充方式 | 实现方 |
| ------------------ | ---- | -------- | -------- | ------ |
| 512~1024（64倍数） | 1024 | 无       | 无       | JDK    |



### 2.2 DH算法实现过程及相关类详解

- 初始化发送方密钥

  - KeyPairGenerator

    通过`KeyPairGenerator`来得到`KeyPair`类的对象

    ```java
    // 创建KeyPairGenerator对象
    KeyPairGenerator keyPairGenerator = 
                      KeyPairGenerator.getInstance("DH");
    ```

    关于`Provider`的内容可查看《JAVA实现Base64加密》课程的1-5小节

  - KeyPair

  - PublicKey （公钥）

- 初始化接收方密钥
  - KeyFactory
  - X509EncodedKeySpec 类根据ASN.1标准进行密钥编码
  - DHPublicKey
  - DHParameterSpec 一些参数的集合
  - KeyPairGenerator
  - PrivateKey

- 密钥构建

  - KeyAgreement 提供密钥一致性（或密钥交换)协议的功能。

    ```JAVA
    //生成实现指定密钥一致算法的KeyAgreement对象
    static KeyAgreement getInstance(String algorithm)
    //为来自指定提供程序的指定密钥一致算法生成一个KeyAgreement对象
    static KeyAgreement getInstance(String algorithm, Provider provider)
    ```

  - SecretKey 生成一个分组的密文秘钥

  - KeyFactory

  - X509EncodedKeySpec

  - PublicKey

- 加密、解密

  - Cipher 为加密解密提供密码的功能

    ```java
    Cipher cipher=Cipher.getInstance("DES");
    ```

    

### 2.3 DH算法实现

查看项目代码

非对称加密算法DH操作过程



![](/images/非对称加密算法DH.jpg)



## 第3章 RSA算法

### 3.1 RSA算法实现及应用

非对称加密算法 —— RSA

- 唯一广泛接受并实现
- 数据加密&数字签名
- 公钥加密、私钥解密
- 私钥加密、公钥加密



| 密钥长度              | 默认 | 工作模式 | 填充方式                                                     | 实现方 |
| --------------------- | ---- | -------- | ------------------------------------------------------------ | ------ |
| 512~65536（64整数倍） | 1024 | ECB      | NoPadding、PKCS1Padding、OAEPWITHMD5AndMGF1Pading、OAEPWITHSHA1AndMGF1Pading、OAEPWITHSHA256AndMGF1Pading、OAEPWITHSHA384AndMGF1Pading、OAEPWITHSHA512AndMGF1Pading | JDK    |
| 512~65536（64整数倍） | 2048 | NONE     | NoPadding、PKCS1Padding、OAEPWITHMD5AndMGF1Pading、OAEPWITHSHA1AndMGF1Pading、OAEPWITHSHA224AndMGF1Pading、OAEPWITHSHA256AndMGF1Pading、OAEPWITHSHA384AndMGF1Pading、OAEPWITHSHA512AndMGF1Pading、ISO9796-1Padding | BC     |



![](/images/RSA非对称加密操作过程.jpg)



## 第4章 ElGamal算法

非对称加密算法 —— ElGamal

- 只提供公钥加密算法
- Bouncy Castle（JDK里没的提供实现）

| 密钥长度               | 默认 | 工作模式  | 填充方式                                                     | 实现方 |
| ---------------------- | ---- | --------- | ------------------------------------------------------------ | ------ |
| 160~16384（8的整数倍） | 1024 | ECB、NONE | NoPadding、PKCS1Padding、OAEPWITHMD5AndMGF1Pading、OAEPWITHSHA1AndMGF1Pading、OAEPWITHSHA224AndMGF1Pading、OAEPWITHSHA256AndMGF1Pading、OAEPWITHSHA384AndMGF1Pading、OAEPWITHSHA512AndMGF1pading、ISo9796-1Padding | BC     |



![](/images/ElGamal算法操作过程.jpg)



