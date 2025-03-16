package cn.itcast.jaxb.case2;

import javax.xml.bind.JAXBException;
import java.io.FileNotFoundException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;


/**
 * 一、简介：
 *
 * 本文主要介绍 marshaller、unmarshaller 的使用，并附上简单的实例，DOM 解析和 SAX 解析大家应该众所周知，这里就不介绍了，自行百度或查看文档即可，
 * marshaller 简直就是神器，下面我们就来介绍一下。
 *
 * 首先，我们来介绍一下 marshaller、unmarshaller 有什么用，及 API 的简单介绍, JAXB（Java Architecture for XML Binding) 是一个业界的标准，
 * 是一项可以根据 XML Schema 产生 Java 类的技术。该过程中，JAXB 也提供了对 XML 的实例文档反向生成 JAVA 对象树的方法，并能将Java对象树的内容重新写
 * 到 XML 实例文档。从另一方面来讲，JAXB 提供了快速而简便的方法将 XML 模式绑定到 Java 表示，从而使得 Java 开发者在 Java 应用程序中能方便地结合 XML
 * 数据和处理函数。
 *
 * 原文链接：https://blog.csdn.net/cccdddbbb88/article/details/134128832
 */
public class JAXBTest2 {

    public static void main(String[] args) throws JAXBException, FileNotFoundException {
        ReqHeader reqHeader = new ReqHeader();
        reqHeader.setReqNo("1");
        reqHeader.setAuthCode("AAA");
        reqHeader.setSysId("AAA123");

        SmsBody smsBody1 = new SmsBody();
        smsBody1.setContent("测试1");
        smsBody1.setDestAddr("15888");
        smsBody1.setSourceAddr("888");

        SmsBody smsBody2 = new SmsBody();
        smsBody2.setContent("测试2");
        smsBody2.setDestAddr("159898");
        smsBody2.setSourceAddr("989898");

        List<SmsBody> smsBodys = new ArrayList<SmsBody>();
        smsBodys.add(smsBody1);
        smsBodys.add(smsBody2);

        SmsDeliverReq smsDeliverReq = new SmsDeliverReq();
        smsDeliverReq.setReqHeader(reqHeader);
        smsDeliverReq.setSmsBodys(smsBodys);

        StringWriter sw = JAXBUtil.beanToXml(smsDeliverReq);
        System.out.println(sw.toString());

        SmsDeliverReq xmlToBean = JAXBUtil.xmlToBean(sw.toString(), smsDeliverReq);
        System.out.println(xmlToBean.getSmsBodys());

        System.out.println(xmlToBean.getSmsBodys().get(0).getContent());

    }

}
