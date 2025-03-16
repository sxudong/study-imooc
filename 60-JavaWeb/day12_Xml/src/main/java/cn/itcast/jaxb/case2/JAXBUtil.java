package cn.itcast.jaxb.case2;


import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.StringReader;
import java.io.StringWriter;


/**
 * marshaller ：
 *   从官网文档来说，marshaller类 负责管理将 Java 内容树序列化为 XML 数据的过程。简单的来说可以把 java 对象序列话为转为 XML 格式的数据。
 *
 * Unmarshaller：
 *   从官网文档来说，Unmarshaller类 管理将 XML 数据反序列化到新创建的 Java 内容树中的过程，在未编组的情况下，还可以对 XML 数据进行验证。
 *   简单的来说。可以把 XML 格式的数据反序列化并且把数据绑定在 Java bean 的属性上。
 *
 * 原文链接：https://blog.csdn.net/cccdddbbb88/article/details/134128832
 */
public class JAXBUtil {


    /**
     * XML 转转为 JavaBean
     */
    public static <T> T xmlToBean(String xml, T t) throws JAXBException {
        // 创建 JAXB 上下文
        JAXBContext context = JAXBContext.newInstance(t.getClass());
        Unmarshaller um = context.createUnmarshaller();
        StringReader sr = new StringReader(xml);
        t = (T) um.unmarshal(sr);
        return t;
    }

    /**
     * JavaBean 转换为 XML
     */
    public static <T> StringWriter beanToXml(T t) throws JAXBException, FileNotFoundException {
        // 创建 JAXB 上下文
        JAXBContext context = JAXBContext.newInstance(t.getClass());
        Marshaller m = context.createMarshaller();
        StringWriter sw = new StringWriter();
        m.marshal(t,sw);
        // 设置格式化输出
        m.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT,true);
        // 将 Java 对象转换为 XML 并保存到文件
        m.marshal(t, new FileOutputStream("/test.xml"));
        m.marshal(t, System.out);
        return sw;
    }
}
