package cn.itcast.jaxb.case1;

import javax.xml.bind.*;
import java.io.File;
import java.io.FileOutputStream;


/**
 * JAXB Users Guide:
 * https://github.com/javaee/jaxb-v2
 * https://javaee.github.io/jaxb-v2/doc/user-guide/ch03.html#compiling-xml-schema-mapping-of-xs-element-to-jaxbelement
 *
 * 官网下载 JAXB:
 * https://thorben-janssen.com/generate-your-jaxb-classes-in-second/
 */
public class JAXBTest1 {

    /**
     * @XmlAccessorType 注解用于指定 JAXB 应该使用属性访问器而非字段访问器，
     * @XmlType 注解用于指定类的名称和属性顺序
     * @XmlRootElement 注解用于指定类在 XML 文档中的根元素名称
     * @XmlAccessorOrder 控制 JAXB 绑定类中属性和字段的排序。
     * @XmlJavaTypeAdapter 使用定制的适配器（即扩展抽象类 XmlAdapter 并覆盖 marshal() 和 unmarshal()方法），以序列化 Java 类为 XML。
     * @XmlElementWrapper  对于数组或集合（即包含多个元素的成员变量），生成一个包装该数组或集合的XML元素（称为包装器）。
     *                     注意：@XmlElementWrapper 仅允许出现在集合属性上。
     * @XmlElement 将Java类的一个属性映射到与属性同名的一个XML元素。
     * @XmlAttribute 将Java类的一个属性映射到与属性同名的一个XML属性。注意：序列化的 java 类的成员遍历不能声明为 public 的，
     * <p>
     * 运行 xjc 工具生成Java代码：
     * C:\Program Files\Java\jdk1.8.0_172\bin> xjc D:\Aaron\person.xsd -d  D:\Aaron\src -p com.boc
     * <p>
     * -d 参数指定生成的 Java 类的输出目录，
     * -p 参数指定生成的 Java 类的包名
     * 该命令会自动生成一个名为 PersonType.java 的 Java 类和名为 addressType.java 的 Java 类，
     * 以及一个名为 ObjectFactory.java 的工厂类，用于创建 JAXBContext 对象
     * <p>
     * 原文链接：https://blog.csdn.net/qq_44166712/article/details/130741718
     */
    public static void main(String[] args) throws Exception {
        test1();
        test2();
    }


    public static void test1() throws Exception {
        // 通过 ObjectFactory 来解析 xml 文件 (依赖 jaxb-runtime jar 包)
        JAXBContext jaxbContext = JAXBContext.newInstance(ObjectFactory.class);
        Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
        File xmlFile = new File("G:\\IDworkspace\\study-imooc\\60-JavaWeb\\day12_Xml\\src\\main\\resources\\person.xml");
        JAXBElement<?> jaxbElement = (JAXBElement<?>) unmarshaller.unmarshal(xmlFile);
        PersonType personType = (PersonType) jaxbElement.getValue();
        //AddressType addressType = (AddressType) jaxbElement.getValue(); 会发生报错
        System.out.println(personType.age);

        /**
         * 将 java 对象转换为 xml 文件
         * 需要手动给 PersonType.java 中增加 @XmlRootElement，才能将 java 对象解析成 xml
         */
        PersonType personType2 = new PersonType();
        personType2.setAge(88);

        JAXBContext jaxbContext2 = JAXBContext.newInstance(PersonType.class);
        Marshaller marshaller = jaxbContext2.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true); // 格式化输出
        try (FileOutputStream fileStream = new FileOutputStream("G:\\IDworkspace\\study-imooc\\60-JavaWeb\\day12_Xml\\src\\main\\resources\\person_new.xml")) {
            marshaller.marshal(personType, fileStream);
        }
    }

    public static void test2() throws Exception {
        // xml 转换为 java
        // 通过 ServerConfig 来解析 xml 文件
        JAXBContext jaxbContext = JAXBContext.newInstance(ServerConfig.class);
        Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
        File xmlFile = new File("G:\\IDworkspace\\study-imooc\\60-JavaWeb\\day12_Xml\\src\\main\\resources\\server_config.xml");
        // 转换为 Java 对象
        ServerConfig serverConfig = (ServerConfig) unmarshaller.unmarshal(xmlFile);
        System.out.println(serverConfig.getServerInfo().getServerId());

        // Java 转换为 xml
        ServerConfig.BadiduInfo badiduInfo = new ServerConfig.BadiduInfo();
        badiduInfo.setUrl("www.baidu.com");
        serverConfig.setBadiduInfo(badiduInfo);

        jaxbContext = JAXBContext.newInstance(ServerConfig.class);
        Marshaller marshaller = jaxbContext.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true); // 格式化输出
        try (FileOutputStream fileStream = new FileOutputStream("G:\\IDworkspace\\study-imooc\\60-JavaWeb\\day12_Xml\\src\\main\\resources\\server_config_new.xml")) {
            marshaller.marshal(serverConfig, fileStream);
        }
    }
}
