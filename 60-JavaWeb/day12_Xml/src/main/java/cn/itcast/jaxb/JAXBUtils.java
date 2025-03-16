package cn.itcast.jaxb;
 
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.io.File;
 
public class JAXBUtils {
    public static void writeXML(Object obj, File path, Class... clazz) throws JAXBException {
        JAXBContext jctx = JAXBContext.newInstance(clazz);
        Marshaller marshaller = jctx.createMarshaller();
        // 格式化输出，设置换行和缩进，不设置则会显示在一行
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        marshaller.marshal(obj, path);
        // 设置控制台输出
        marshaller.marshal(obj, System.out);
    }
 
    public static Object readXML(File path, Class... clazz) throws JAXBException {
        JAXBContext jctx = JAXBContext.newInstance(clazz);
        Unmarshaller unMarshaller = jctx.createUnmarshaller();
        Object obj = unMarshaller.unmarshal(path);
 
        return obj;
    }
}