package cn.itcast.jaxb.case1;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.io.File;
import java.io.FileOutputStream;


public class JAXBTest1 {

    /**
     * @XmlAccessorType 注解用于指定 JAXB 应该使用属性访问器而非字段访问器，
     * @XmlType 注解用于指定类的名称和属性顺序
     * @XmlRootElement 注解用于指定类在 XML 文档中的根元素名称
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
        // 通过 ObjectFactory 来解析 xml 文件
        JAXBContext jaxbContext = JAXBContext.newInstance(ObjectFactory.class);
        Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
        File xmlFile = new File("G:\\IDworkspace\\study-imooc\\60-JavaWeb\\day12_Xml\\src\\main\\resources\\person.xml");
        // JAXBElement 是 ObjectFactory
        JAXBElement<?> jaxbElement = (JAXBElement<?>) unmarshaller.unmarshal(xmlFile);
        PersonType personType = (PersonType) jaxbElement.getValue();
        //AddressType addressType = (AddressType) jaxbElement.getValue(); 会发生报错
        System.out.println(personType.age);

        /**
         * 将 java 对象转换为 xml 文件
         * 需要手动给 PersonType.jav a中增加 @XmlRootElement，才能将 java 对象解析成 xml
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
}
