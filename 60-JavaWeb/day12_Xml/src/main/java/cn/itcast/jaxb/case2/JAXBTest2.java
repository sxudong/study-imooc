package cn.itcast.jaxb.case2;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.io.File;
import java.io.FileOutputStream;


public class JAXBTest2 {

    public static void main(String[] args) throws Exception {
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
